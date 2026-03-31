#!/usr/bin/env python3
"""
Stringent undiscovered logic path discovery for ENS contracts.
Analyzes all code paths, edge cases, conditional branches, and unusual patterns.
"""

import json
import re
from pathlib import Path
from collections import defaultdict
import ast

class LogicPathAnalyzer:
    def __init__(self):
        self.paths = defaultdict(list)
        self.edge_cases = []
        self.unusual_patterns = []
        self.complex_branches = []
        self.hidden_paths = []
        self.state_transitions = []
        
    def analyze_conditionals(self, content, contract_name, file_path):
        """Find all conditional branches and analyze complexity."""
        findings = []
        
        # Find all if/else/elseif statements
        if_pattern = r'if\s*\(([^)]+)\)\s*\{'
        if_matches = list(re.finditer(if_pattern, content))
        
        for match in if_matches:
            condition = match.group(1)
            start_pos = match.start()
            
            # Find the full if-else block
            brace_count = 0
            block_end = start_pos
            in_block = False
            
            for i, char in enumerate(content[start_pos:], start_pos):
                if char == '{':
                    brace_count += 1
                    in_block = True
                elif char == '}':
                    brace_count -= 1
                    if brace_count == 0 and in_block:
                        block_end = i
                        break
            
            # Analyze condition complexity
            complexity = self.analyze_condition_complexity(condition)
            
            # Check for edge cases
            edge_cases = self.find_edge_cases_in_condition(condition)
            
            findings.append({
                "type": "conditional",
                "contract": contract_name,
                "file": file_path,
                "condition": condition.strip(),
                "position": f"Line ~{content[:start_pos].count(chr(10)) + 1}",
                "complexity": complexity,
                "edge_cases": edge_cases,
                "code_snippet": content[start_pos:block_end+1][:200]
            })
        
        return findings
    
    def analyze_condition_complexity(self, condition):
        """Analyze complexity of a condition."""
        complexity = {
            "operators": len(re.findall(r'[&|!<>=]', condition)),
            "nested_parens": condition.count('(') + condition.count(')'),
            "has_require": 'require' in condition.lower(),
            "has_revert": 'revert' in condition.lower(),
            "has_assert": 'assert' in condition.lower(),
            "multiple_conditions": condition.count('&&') + condition.count('||'),
        }
        complexity["score"] = (
            complexity["operators"] * 2 +
            complexity["nested_parens"] +
            complexity["multiple_conditions"] * 3
        )
        return complexity
    
    def find_edge_cases_in_condition(self, condition):
        """Find potential edge cases in conditions."""
        edge_cases = []
        
        # Zero address checks
        if 'address(0)' in condition or 'address(0x0)' in condition:
            edge_cases.append("Zero address check")
        
        # Zero value checks
        if re.search(r'==\s*0\b|!=\s*0\b|>\s*0\b|<\s*0\b', condition):
            edge_cases.append("Zero value check")
        
        # Max/min value checks
        if 'type(uint' in condition or 'type(int' in condition:
            edge_cases.append("Type max/min value")
        
        # Timestamp comparisons
        if 'block.timestamp' in condition:
            edge_cases.append("Timestamp dependency - manipulable")
        
        # Block number
        if 'block.number' in condition:
            edge_cases.append("Block number dependency")
        
        # Array/string length
        if '.length' in condition:
            edge_cases.append("Length check - potential overflow")
        
        # Balance checks
        if '.balance' in condition or 'balanceOf' in condition:
            edge_cases.append("Balance check")
        
        # Existence checks
        if 'exists' in condition.lower() or 'owner' in condition.lower():
            edge_cases.append("Existence check")
        
        return edge_cases
    
    def analyze_function_paths(self, content, contract_name, file_path):
        """Analyze all function execution paths."""
        findings = []
        
        # Find all functions
        function_pattern = r'function\s+(\w+)\s*\([^)]*\)\s*(?:public|external|internal|private)?\s*(?:view|pure|payable)?'
        functions = list(re.finditer(function_pattern, content))
        
        for func_match in functions:
            func_name = func_match.group(1)
            func_start = func_match.start()
            
            # Find function body
            body_start = content.find('{', func_start)
            if body_start == -1:
                continue
            
            # Find matching closing brace
            brace_count = 0
            body_end = body_start
            for i, char in enumerate(content[body_start:], body_start):
                if char == '{':
                    brace_count += 1
                elif char == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        body_end = i
                        break
            
            func_body = content[body_start:body_end+1]
            
            # Analyze execution paths
            paths = self.trace_execution_paths(func_body, func_name)
            
            # Find external calls
            external_calls = self.find_external_calls(func_body)
            
            # Find state changes
            state_changes = self.find_state_changes(func_body)
            
            # Find loops
            loops = self.find_loops(func_body)
            
            # Check for unusual patterns
            unusual = self.find_unusual_patterns(func_body, func_name)
            
            findings.append({
                "function": func_name,
                "contract": contract_name,
                "file": file_path,
                "execution_paths": paths,
                "external_calls": external_calls,
                "state_changes": state_changes,
                "loops": loops,
                "unusual_patterns": unusual,
                "complexity_score": self.calculate_complexity(func_body)
            })
        
        return findings
    
    def trace_execution_paths(self, body, func_name):
        """Trace all possible execution paths through a function."""
        paths = []
        
        # Count branches
        if_count = body.count('if (')
        require_count = body.count('require(')
        revert_count = body.count('revert')
        return_count = body.count('return ')
        
        # Estimate path count (exponential with branches)
        estimated_paths = max(1, 2 ** if_count)
        
        paths.append({
            "estimated_paths": estimated_paths,
            "if_statements": if_count,
            "requires": require_count,
            "reverts": revert_count,
            "returns": return_count,
            "complexity": "HIGH" if estimated_paths > 16 else "MEDIUM" if estimated_paths > 4 else "LOW"
        })
        
        return paths
    
    def find_external_calls(self, body):
        """Find all external calls."""
        calls = []
        
        patterns = [
            (r'\.call\s*\(', 'Low-level call'),
            (r'\.delegatecall\s*\(', 'Delegatecall'),
            (r'\.transfer\s*\(', 'Transfer'),
            (r'\.send\s*\(', 'Send'),
            (r'\.transferFrom\s*\(', 'TransferFrom'),
            (r'\.safeTransferFrom\s*\(', 'SafeTransferFrom'),
            (r'\([^)]+\)\s*\.\w+\s*\(', 'External contract call'),
        ]
        
        for pattern, desc in patterns:
            matches = re.finditer(pattern, body)
            for match in matches:
                calls.append({
                    "type": desc,
                    "position": f"Char {match.start()}",
                    "snippet": body[max(0, match.start()-20):match.end()+20]
                })
        
        return calls
    
    def find_state_changes(self, body):
        """Find all state variable changes."""
        changes = []
        
        # Assignment patterns
        patterns = [
            (r'(\w+)\s*=\s*[^;]+;', 'Direct assignment'),
            (r'(\w+)\s*\+\+', 'Increment'),
            (r'(\w+)\s*--', 'Decrement'),
            (r'(\w+)\s*\+=\s*', 'Add assign'),
            (r'(\w+)\s*-=\s*', 'Subtract assign'),
            (r'delete\s+(\w+)', 'Delete'),
            (r'mapping\s*\[[^\]]+\]\s*(\w+)\s*=', 'Mapping assignment'),
        ]
        
        for pattern, desc in patterns:
            matches = re.finditer(pattern, body)
            for match in matches:
                var_name = match.group(1) if match.groups() else "unknown"
                changes.append({
                    "type": desc,
                    "variable": var_name,
                    "snippet": body[max(0, match.start()-10):match.end()+10]
                })
        
        return changes
    
    def find_loops(self, body):
        """Find all loops."""
        loops = []
        
        patterns = [
            (r'for\s*\([^)]+\)\s*\{', 'For loop'),
            (r'while\s*\([^)]+\)\s*\{', 'While loop'),
            (r'do\s*\{', 'Do-while loop'),
        ]
        
        for pattern, desc in patterns:
            matches = re.finditer(pattern, body)
            for match in matches:
                loops.append({
                    "type": desc,
                    "position": f"Char {match.start()}",
                    "potential_issues": self.analyze_loop_issues(body, match.start())
                })
        
        return loops
    
    def analyze_loop_issues(self, body, loop_start):
        """Analyze potential issues in loops."""
        issues = []
        
        # Check for gas issues
        loop_body = body[loop_start:loop_start+500]
        if '.length' in loop_body:
            issues.append("Iterates over dynamic array - potential gas issues")
        
        if 'external' in loop_body or '.call(' in loop_body:
            issues.append("External calls in loop - potential DoS")
        
        if 'storage' in loop_body:
            issues.append("Storage operations in loop - expensive")
        
        return issues
    
    def find_unusual_patterns(self, body, func_name):
        """Find unusual or suspicious patterns."""
        patterns = []
        
        # Unchecked blocks
        if 'unchecked' in body:
            patterns.append({
                "type": "unchecked_block",
                "risk": "Overflow/underflow not checked",
                "description": "Arithmetic operations without overflow protection"
            })
        
        # Assembly blocks
        if 'assembly' in body:
            patterns.append({
                "type": "inline_assembly",
                "risk": "Low-level code, harder to audit",
                "description": "Assembly code bypasses Solidity safety checks"
            })
        
        # Selfdestruct
        if 'selfdestruct' in body.lower():
            patterns.append({
                "type": "selfdestruct",
                "risk": "Contract can be destroyed",
                "description": "Selfdestruct call found"
            })
        
        # Create2
        if 'create2' in body.lower():
            patterns.append({
                "type": "create2",
                "risk": "Deterministic address creation",
                "description": "Create2 used - predictable addresses"
            })
        
        # Multiple returns
        return_count = body.count('return ')
        if return_count > 3:
            patterns.append({
                "type": "multiple_returns",
                "risk": "Complex control flow",
                "description": f"Function has {return_count} return statements"
            })
        
        # Deep nesting
        max_nesting = self.calculate_max_nesting(body)
        if max_nesting > 4:
            patterns.append({
                "type": "deep_nesting",
                "risk": "Hard to understand and test",
                "description": f"Maximum nesting depth: {max_nesting}"
            })
        
        # Try-catch
        if 'try' in body and 'catch' in body:
            patterns.append({
                "type": "try_catch",
                "risk": "Error handling complexity",
                "description": "Try-catch block found"
            })
        
        return patterns
    
    def calculate_max_nesting(self, body):
        """Calculate maximum nesting depth."""
        max_depth = 0
        current_depth = 0
        
        for char in body:
            if char == '{':
                current_depth += 1
                max_depth = max(max_depth, current_depth)
            elif char == '}':
                current_depth -= 1
        
        return max_depth
    
    def calculate_complexity(self, body):
        """Calculate cyclomatic complexity."""
        complexity = 1  # Base complexity
        
        # Add for each decision point
        complexity += body.count('if (')
        complexity += body.count('else if')
        complexity += body.count('case ')
        complexity += body.count('while (')
        complexity += body.count('for (')
        complexity += body.count('&&')
        complexity += body.count('||')
        complexity += body.count('catch')
        complexity += body.count('?')  # Ternary operators
        
        return {
            "cyclomatic": complexity,
            "rating": "VERY_HIGH" if complexity > 20 else "HIGH" if complexity > 10 else "MEDIUM" if complexity > 5 else "LOW"
        }
    
    def analyze_hidden_paths(self, content, contract_name, file_path):
        """Find hidden or rarely-used code paths."""
        hidden = []
        
        # Functions with no external visibility
        internal_funcs = re.findall(r'function\s+(\w+)\s*\([^)]*\)\s*internal', content)
        private_funcs = re.findall(r'function\s+(\w+)\s*\([^)]*\)\s*private', content)
        
        for func in internal_funcs + private_funcs:
            # Check if function is called
            call_count = content.count(f'{func}(')
            if call_count <= 1:  # Only definition
                hidden.append({
                    "type": "unused_function",
                    "contract": contract_name,
                    "file": file_path,
                    "function": func,
                    "visibility": "internal" if func in internal_funcs else "private",
                    "risk": "Dead code or hidden functionality"
                })
        
        # Unreachable code (after return/revert)
        # This is complex to detect statically, but we can flag suspicious patterns
        
        # Commented out code
        commented_code = re.findall(r'//.*function|/\*.*function.*\*/', content, re.DOTALL)
        if commented_code:
            hidden.append({
                "type": "commented_code",
                "contract": contract_name,
                "file": file_path,
                "risk": "May indicate incomplete implementation"
            })
        
        return hidden
    
    def analyze_state_transitions(self, content, contract_name, file_path):
        """Analyze state machine transitions."""
        transitions = []
        
        # Find state variables
        state_vars = re.findall(r'(?:public|private|internal)\s+\w+\s+(\w+);', content)
        
        # Find functions that modify state
        functions = re.finditer(r'function\s+(\w+)\s*\([^)]*\)', content)
        
        for func_match in functions:
            func_name = func_match.group(1)
            func_start = func_match.start()
            body_start = content.find('{', func_start)
            if body_start == -1:
                continue
            
            # Find function body
            brace_count = 0
            body_end = body_start
            for i, char in enumerate(content[body_start:], body_start):
                if char == '{':
                    brace_count += 1
                elif char == '}':
                    brace_count -= 1
                    if brace_count == 0:
                        body_end = i
                        break
            
            func_body = content[body_start:body_end+1]
            
            # Find which state variables are modified
            modified_vars = []
            for var in state_vars:
                if re.search(rf'\b{var}\s*[=+\-]', func_body) or f'delete {var}' in func_body:
                    modified_vars.append(var)
            
            if modified_vars:
                transitions.append({
                    "function": func_name,
                    "contract": contract_name,
                    "file": file_path,
                    "modified_state": modified_vars,
                    "transition_complexity": len(modified_vars)
                })
        
        return transitions

def main():
    """Main analysis function."""
    contracts_dir = Path("contracts")
    output_dir = Path("decomposition/logic_paths")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    analyzer = LogicPathAnalyzer()
    
    print("=" * 60)
    print("STRINGENT LOGIC PATH DISCOVERY")
    print("=" * 60)
    print()
    
    all_findings = {
        "conditionals": [],
        "function_paths": [],
        "hidden_paths": [],
        "state_transitions": [],
        "edge_cases": [],
        "unusual_patterns": []
    }
    
    contract_dirs = sorted([d for d in contracts_dir.iterdir() if d.is_dir()])
    
    for contract_dir in contract_dirs:
        contract_name = contract_dir.name
        print(f"Analyzing logic paths in {contract_name}...")
        
        sol_files = list(contract_dir.rglob("*.sol"))
        for sol_file in sol_files:
            if not sol_file.is_file():
                continue
            
            try:
                with open(sol_file, 'r', encoding='utf-8') as f:
                    content = f.read()
            except Exception:
                continue
            
            rel_path = str(sol_file.relative_to(contract_dir))
            
            # Run all analyses
            conditionals = analyzer.analyze_conditionals(content, contract_name, rel_path)
            function_paths = analyzer.analyze_function_paths(content, contract_name, rel_path)
            hidden = analyzer.analyze_hidden_paths(content, contract_name, rel_path)
            transitions = analyzer.analyze_state_transitions(content, contract_name, rel_path)
            
            all_findings["conditionals"].extend(conditionals)
            all_findings["function_paths"].extend(function_paths)
            all_findings["hidden_paths"].extend(hidden)
            all_findings["state_transitions"].extend(transitions)
    
    # Generate summary
    print("\nGenerating comprehensive logic path analysis...")
    
    # Save full report
    report_file = output_dir / "logic_path_analysis.json"
    with open(report_file, 'w') as f:
        json.dump(all_findings, f, indent=2)
    
    # Generate markdown summary
    md_file = output_dir / "logic_path_analysis.md"
    with open(md_file, 'w') as f:
        f.write("# Stringent Logic Path Discovery - ENS Contracts\n\n")
        f.write("## Summary\n\n")
        f.write(f"- **Total Conditionals Analyzed**: {len(all_findings['conditionals'])}\n")
        f.write(f"- **Total Functions Analyzed**: {len(all_findings['function_paths'])}\n")
        f.write(f"- **Hidden Paths Found**: {len(all_findings['hidden_paths'])}\n")
        f.write(f"- **State Transitions**: {len(all_findings['state_transitions'])}\n\n")
        
        # Complex conditionals
        complex_conds = [c for c in all_findings['conditionals'] if c['complexity']['score'] > 10]
        if complex_conds:
            f.write("## Complex Conditionals (High Risk)\n\n")
            for cond in sorted(complex_conds, key=lambda x: x['complexity']['score'], reverse=True)[:20]:
                f.write(f"### {cond['contract']} - {cond['file']}\n")
                f.write(f"- **Condition**: `{cond['condition'][:100]}`\n")
                f.write(f"- **Complexity Score**: {cond['complexity']['score']}\n")
                f.write(f"- **Edge Cases**: {', '.join(cond['edge_cases']) if cond['edge_cases'] else 'None'}\n")
                f.write(f"- **Position**: {cond['position']}\n\n")
        
        # High complexity functions
        complex_funcs = [f for f in all_findings['function_paths'] 
                        if f['complexity_score']['rating'] in ['HIGH', 'VERY_HIGH']]
        if complex_funcs:
            f.write("## High Complexity Functions\n\n")
            for func in sorted(complex_funcs, 
                             key=lambda x: x['complexity_score']['cyclomatic'], 
                             reverse=True)[:20]:
                f.write(f"### {func['contract']}::{func['function']}\n")
                f.write(f"- **File**: `{func['file']}`\n")
                f.write(f"- **Cyclomatic Complexity**: {func['complexity_score']['cyclomatic']}\n")
                f.write(f"- **Rating**: {func['complexity_score']['rating']}\n")
                f.write(f"- **Estimated Paths**: {func['execution_paths'][0]['estimated_paths']}\n")
                f.write(f"- **External Calls**: {len(func['external_calls'])}\n")
                f.write(f"- **State Changes**: {len(func['state_changes'])}\n")
                if func['unusual_patterns']:
                    f.write(f"- **Unusual Patterns**: {', '.join([p['type'] for p in func['unusual_patterns']])}\n")
                f.write("\n")
        
        # Hidden paths
        if all_findings['hidden_paths']:
            f.write("## Hidden or Unused Code Paths\n\n")
            for hidden in all_findings['hidden_paths']:
                f.write(f"### {hidden['contract']}\n")
                f.write(f"- **Type**: {hidden['type']}\n")
                f.write(f"- **File**: `{hidden['file']}`\n")
                if 'function' in hidden:
                    f.write(f"- **Function**: `{hidden['function']}`\n")
                f.write(f"- **Risk**: {hidden['risk']}\n\n")
        
        # State transitions
        complex_transitions = [t for t in all_findings['state_transitions'] 
                             if t['transition_complexity'] > 3]
        if complex_transitions:
            f.write("## Complex State Transitions\n\n")
            for trans in sorted(complex_transitions, 
                              key=lambda x: x['transition_complexity'], 
                              reverse=True)[:20]:
                f.write(f"### {trans['contract']}::{trans['function']}\n")
                f.write(f"- **Modified State Variables**: {', '.join(trans['modified_state'])}\n")
                f.write(f"- **Complexity**: {trans['transition_complexity']}\n\n")
    
    print(f"\nLogic path analysis complete!")
    print(f"Full report: {report_file}")
    print(f"Summary: {md_file}")
    print(f"\nTotal conditionals: {len(all_findings['conditionals'])}")
    print(f"Total functions: {len(all_findings['function_paths'])}")
    print(f"Hidden paths: {len(all_findings['hidden_paths'])}")
    print(f"State transitions: {len(all_findings['state_transitions'])}")

if __name__ == "__main__":
    main()



