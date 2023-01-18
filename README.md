## Run tests

Run tests on fork of mainnet.

### Working Test 
which doesn't use NFT balanceOf(address) function:
```
forge test --fork-url https://rpc.ankr.com/eth --match-contract ShellzOrbWorkingTest
```
sample output:
```
Running 4 tests for test/ShellzOrb.t.sol:ShellzOrbWorkingTest
[PASS] testBalanceOf() (gas: 125600)
[PASS] testImmutableVariables() (gas: 26613)
[PASS] testOnlyInitializeOnce() (gas: 18230)
[PASS] testOwner() (gas: 24760)
```

### Working Test 2
which deploys new contract instances:
```
forge test --fork-url https://rpc.ankr.com/eth --match-contract ShellzOrbWorkingTest2
```
sample output:
```
Running 4 tests for test/ShellzOrb.t.sol:ShellzOrbWorkingTest2
[PASS] testBalanceOf() (gas: 927405)
[PASS] testImmutableVariables() (gas: 26481)
[PASS] testOnlyInitializeOnce() (gas: 18197)
[PASS] testOwner() (gas: 24727)
Test result: ok. 4 passed; 0 failed; finished in 4.33s
```

### Test With Issue

```
forge test --fork-url https://rpc.ankr.com/eth --match-contract ShellzOrbTest       
```

test hangs indefinitely after compilation:
```
[⠒] Compiling...
[⠊] Compiling 1 files with 0.8.17
[⠢] Solc 0.8.17 finished in 5.47s
Compiler run successful

```

Only tests which use balanceOf function on already deployed mainnet instances of the NFT contracts fail in this way. Removing any balanceOf calls or deploying new instances as demonstrated in the above working tests gets around the issue. 

You can query `balanceOf` for the mainnet contracts through etherscan: https://etherscan.io/token/0xe17827609ac34443b3987661f4e037642f6bd9ba#readProxyContract#F1 
with the example address used in the broken test "0xea831d27E0E52b4dC32F42A5c4C5cBfd9b6D4a58"
