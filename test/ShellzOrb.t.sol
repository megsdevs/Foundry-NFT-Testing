// SPDX-License-Identifier: MIT
// Built for Shellz Orb by megsdevs
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "contracts/ShellzOrbV2.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";


contract ShellzOrbUpgradeTest is Test {
    // proxy admin contract to control proxy 
    // see https://docs.openzeppelin.com/contracts/3.x/api/proxy#ProxyAdmin
    // mainnet impl v2 contract
    ShellzOrbV2 implementation = ShellzOrbV2(address(0x0a1618A6F0b9D3E37DC673AB1cd67471760bC06A));
    // mainnet admin contract
    ProxyAdmin admin = ProxyAdmin(address(0x523422E7671b1F4Cb148ec5BC8848d6175b8Dcb0));
    // mainnet proxy contract
    TransparentUpgradeableProxy proxy = TransparentUpgradeableProxy(payable(address(0xe17827609Ac34443B3987661f4e037642F6BD9bA)));

    ShellzOrbV2 wrappedProxy;

    // mainnet EOAs
    address jamieson = address(0x3b6312d78Bc3Bb215842D054627c3A2B22f2bd9c);
    address topHolder = address(0xea831d27E0E52b4dC32F42A5c4C5cBfd9b6D4a58);  // holyshellzbatman.eth

    uint256 afterBalance;
    uint256 beforeBalance;

    function setUp() external {
        // // act as contract owner
        // vm.startPrank(jamieson);

        // // deploy new contracts to get around rpc issue
        // implementation = new ShellzOrb();
        // proxy = new TransparentUpgradeableProxy(address(implementation), address(admin), "");
        
        // wrap in ABI to support easier calls
        wrappedProxy = ShellzOrbV2(address(proxy));

        // wrappedProxy.initialize();  // dont use if using ready initialized mainnet contracts
        // wrappedProxy.devMint(topHolder, 250);  // dont use if using real mainnet contracts as already at max supply

        // vm.stopPrank();
    }

    function testOwner() public {
        assertEq(wrappedProxy.owner(), address(jamieson));
        assertEq(admin.owner(), address(jamieson));
    }

    function testOnlyInitializeOnce() public {
        vm.expectRevert("Initializable: contract is already initialized");
        wrappedProxy.initialize();
    }

    function testImmutableVariables() public {
        assertEq(wrappedProxy.name(), "Shellz Orb");
        assertEq(wrappedProxy.symbol(), "SHELLZ");
        assertEq(wrappedProxy.getMaxLaunchpadSupply(), 1000);
        assertEq(wrappedProxy.supportsInterface(type(IERC721Upgradeable).interfaceId), true);
    }

    function testBalanceOf() public {
        beforeBalance = wrappedProxy.balanceOf(topHolder);  // hangs here if use real mainnet contracts
        console.log("Balance of top holder: %s", beforeBalance);

        vm.prank(wrappedProxy.launchpad());
        wrappedProxy.mintTo(topHolder, 4);

        afterBalance = wrappedProxy.balanceOf(topHolder);  // hangs here if use real mainnet contracts
        console.log("Balance of top holder after mint 4: %s", afterBalance);
        assertEq(afterBalance-beforeBalance, 4);
    }

}