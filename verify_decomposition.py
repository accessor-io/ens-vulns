#!/usr/bin/env python3
"""
Verify decomposition completeness.
"""

import json
from pathlib import Path

def verify_decomposition():
    """Verify all decomposition components are complete."""
    issues = []
    
    # Load contract index
    index_file = Path("decomposition/contract_index.json")
    if not index_file.exists():
        issues.append("Missing: decomposition/contract_index.json")
        return issues
    
    with open(index_file, 'r') as f:
        contracts = json.load(f)
    
    print(f"Total contracts: {len(contracts)}")
    
    # Check analysis files
    analysis_dir = Path("decomposition/analysis")
    reports_dir = Path("decomposition/reports")
    security_dir = Path("decomposition/security_analysis")
    
    contracts_with_source = [c for c in contracts if c["source_files"] > 0]
    contracts_with_metadata = [c for c in contracts if c["has_metadata"]]
    
    print(f"Contracts with source: {len(contracts_with_source)}")
    print(f"Contracts with metadata: {len(contracts_with_metadata)}")
    
    # Check analysis JSON files
    missing_analysis = []
    for contract in contracts:
        analysis_file = analysis_dir / f"{contract['name']}_analysis.json"
        if not analysis_file.exists():
            missing_analysis.append(contract['name'])
    
    if missing_analysis:
        issues.append(f"Missing analysis JSON files: {missing_analysis}")
    else:
        print(f"✓ All {len(contracts)} contracts have analysis JSON files")
    
    # Check markdown templates (for contracts with source)
    missing_md = []
    for contract in contracts_with_source:
        md_file = analysis_dir / f"{contract['name']}.md"
        if not md_file.exists():
            missing_md.append(contract['name'])
    
    if missing_md:
        issues.append(f"Missing markdown templates: {missing_md}")
    else:
        print(f"✓ All {len(contracts_with_source)} contracts with source have markdown templates")
    
    # Check reports
    required_reports = [
        "decomposition_summary.md",
        "full_decomposition_report.json"
    ]
    
    for report in required_reports:
        report_file = reports_dir / report
        if not report_file.exists():
            issues.append(f"Missing report: {report}")
        else:
            print(f"✓ Report exists: {report}")
    
    # Check security analysis
    security_reports = [
        "full_security_report.json",
        "security_analysis_report.md",
        "DEEP_SECURITY_ANALYSIS.md"
    ]
    
    for report in security_reports:
        report_file = security_dir / report
        if not report_file.exists():
            issues.append(f"Missing security report: {report}")
        else:
            print(f"✓ Security report exists: {report}")
    
    # Check security analysis per contract (for contracts with source)
    missing_security = []
    for contract in contracts_with_metadata:
        security_file = security_dir / f"{contract['name']}_security.json"
        if not security_file.exists():
            missing_security.append(contract['name'])
    
    if missing_security:
        print(f"⚠ Missing security analysis for {len(missing_security)} contracts: {missing_security[:5]}...")
    else:
        print(f"✓ All {len(contracts_with_metadata)} contracts with metadata have security analysis")
    
    # Check vulnerability reports
    vuln_dir = Path("decomposition/vulnerabilities")
    vuln_reports = ["CRITICAL_FINDINGS.md", "DETAILED_ANALYSIS.md"]
    
    for report in vuln_reports:
        report_file = vuln_dir / report
        if not report_file.exists():
            issues.append(f"Missing vulnerability report: {report}")
        else:
            print(f"✓ Vulnerability report exists: {report}")
    
    # Summary
    print("\n" + "="*60)
    if issues:
        print("ISSUES FOUND:")
        for issue in issues:
            print(f"  - {issue}")
        return False
    else:
        print("✓ DECOMPOSITION IS COMPLETE")
        print(f"  - {len(contracts)} contracts analyzed")
        print(f"  - {len(contracts_with_source)} contracts with source code")
        print(f"  - All analysis files present")
        print(f"  - All reports generated")
        return True

if __name__ == "__main__":
    success = verify_decomposition()
    exit(0 if success else 1)



