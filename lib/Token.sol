// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.16 <0.6.0;

import "./SafeMath.sol";


contract Token {
	using SafeMath for uint;


	// Variables
	string public name = "DApp token";
	string public symbol = "DApp";
	uint256 public decimals = 18;
	uint256 public totalSupply;

	// Track the balances
	mapping(address => uint256) public balanceOf;
	mapping(address => mapping(address => uint256)) public allowance;

	// Events
	event Transfer(address indexed from, address indexed to, uint256 value );
	event Approval(address indexed owner, address indexed spender, uint256 value);

	constructor() public {
		totalSupply = 1000000 * (10 ** decimals);
		balanceOf[msg.sender] = totalSupply;
	}

	// Send tokens
	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(balanceOf[msg.sender] >= _value);
		_transfer(msg.sender, _to, _value);
		return true;
	}

	function _transfer(address _from, address _to, uint256 _value) internal {
		require(_to != address(0));
		balanceOf[_from] = balanceOf[_from].sub(_value);
		balanceOf[_to] = balanceOf[_to].add(_value);
		emit Transfer(_from, _to, _value);
	}

	//Approve tokens;
	function approve(address _spender, uint256 _value) public returns (bool success) {
		require(_spender != address(0));
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	//TransferFrom
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(_value <= balanceOf[_from]);
		require(_value <= allowance[_from][msg.sender]);
		allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
		_transfer(_from, _to, _value);
		return true;
	}
}
