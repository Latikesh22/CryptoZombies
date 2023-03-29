// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";

contract ZombieFactory is Ownable {
	using SafeMath for uint;
	using SafeCast for uint;

	event NewZombie(uint zombieId, string name, uint dna);

	uint public dnaDigits = 16;
	uint internal dnaModulus = 10**dnaDigits;
	uint public cooldownTime = 1 days;

	struct Zombie {
		string name;
		uint dna;
		uint64 readyTime;
		uint32 level;
		uint16 winCount;
		uint16 lossCount;
	}

	Zombie[] public zombies;

	mapping(uint => address) internal zombieToOwner;

	mapping(address => uint) internal ownerZombieCount;

	function _createZombie(string memory _name, uint _dna) internal {
		zombies.push(Zombie(_name, _dna, uint64(block.timestamp + cooldownTime), 1, 0, 0));
		uint id = zombies.length.sub(1);
		zombieToOwner[id] = msg.sender;
		ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
		emit NewZombie(id, _name, _dna);
	}

	function _generateRandomDna(string memory _str) private view returns (uint) {
		uint rand = uint(keccak256(abi.encodePacked(_str)));
		uint randDna = rand % dnaModulus;
		return randDna;
	}

	function createRandomZombie(string memory _name) public {
		require(ownerZombieCount[msg.sender] == 0, "can't create one original zombie");
		uint randDna = _generateRandomDna(_name);
		_createZombie(_name, randDna);
	}
}
