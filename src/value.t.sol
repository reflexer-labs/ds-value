// Copyright (C) 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity >=0.4.23;

import "ds-test/test.sol";
import "./value.sol";

contract TestUser {
    function doPoke(DSValue value, bytes32 wut) public {
        value.updateResult(wut);
    }

    function doRestartValue(DSValue value) public {
        value.restartValue();
    }
}

contract DSValueTest is DSTest {
    DSValue value;
    bytes32 data = bytes32("test");
    TestUser user;

    function setUp() public {
        value = new DSValue();
        user = new TestUser();
    }

    function testPoke() public {
        value.updateResult(data);
    }

    function testFailPoke() public {
        user.doPoke(value, data);
    }

    function testIsValid() public {
        bytes32 wut; bool isValid;
        (wut, isValid) = value.getResultWithValidity();
        assertTrue(!isValid);
        value.updateResult(data);
        (wut, isValid) = value.getResultWithValidity();
        assertTrue(isValid);
    }

    function testReadWithValidity() public {
        value.updateResult(data);
        bytes32 wut; bool isValid;
        (wut, isValid) = value.getResultWithValidity();
        assertEq(data, wut);
    }

    function testRead() public {
        value.updateResult(data);
        bytes32 wut = value.read();
        assertEq(data, wut);
    }

    function testFailUninitializedRead() public view {
        bytes32 wut = value.read();
        wut;
    }

    function testFailUnsetRead() public {
        value.updateResult(data);
        value.restartValue();
        bytes32 wut = value.read();
        wut;
    }

    function testVoid() public {
        value.updateResult(data);
        bytes32 wut; bool isValid;
        (wut, isValid) = value.getResultWithValidity();
        assertTrue(isValid);
        value.restartValue();
        (wut, isValid) = value.getResultWithValidity();
        assertTrue(!isValid);
    }

    function testFailVoid() public {
        value.updateResult(data);
        user.doRestartValue(value);
    }
}
