pragma solidity ^0.4.23;

contract Workshop {

    string public var1;
    uint public var2;

    constructor () public {
        var1 = "hello";
        var2 = 123;
    }

    function setVar1(string _var1) public {
        var1 = _var1;
    }

    function setVar2(uint _var2) public {
        var2 = _var2;
    }
}