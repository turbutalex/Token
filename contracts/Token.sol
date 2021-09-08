// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import "./IERC20.sol";

contract Token is IERC20 {
    uint256 totalSupplyToken;
    string name;
    string symbol;
    address owner;
    mapping(address => mapping(address => uint256)) public allowances;
    mapping(address => uint256) public balances;

    constructor(string memory _name, string memory _symbol , uint256 _totalSupply){
        name = _name;
        symbol =_symbol;
        totalSupplyToken = _totalSupply;
        owner=msg.sender;
        balances[owner] = _totalSupply;
    }
    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }
    function totalSupply() override external view returns (uint256){
        return totalSupplyToken;
    }
    
//    function mint(address receiving) internal OnlyOwner{
//        balances[receiving]= totalSupply;
//    }
    function balanceOf(address account) override external view returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) override external returns (bool){
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        return true;
    }

    function allowance(address owner, address spender) override external view returns (uint256){
        return allowances[owner][spender];
    }
    function _approve(address owner, address spender , uint256 amount) internal {
        require(balances[owner] >= amount);
        allowances[owner][spender] = amount;
    }
    function approve(address spender, uint256 amount) override external returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) override external returns (bool){
        require(allowances[sender][msg.sender] >= amount);
        balances[recipient] += amount;
        balances[sender] -= amount;
        _approve(sender,msg.sender, allowances[sender][msg.sender] - amount);
        return true;
    }
}
