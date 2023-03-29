// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieFactory.sol";

interface KittyInterface {
	function getKitty(uint _id)
		external
		view
		returns (
			bool isGestating,
			bool isReady,
			uint cooldownIndex,
			uint nextActionAt,
			uint siringWithId,
			uint birthTime,
			uint matronId,
			uint sireId,
			uint generation,
			uint genes
		);
}

contract ZombieFeeding is ZombieFactory {
	KittyInterface internal kittyContract;

	modifier onlyOwnerOf(uint _zombieId) {
		require(msg.sender == zombieToOwner[_zombieId], "unauthorized operation");
		_;
	}

	function setKittyContractAddress(address _address) external onlyOwner {
		kittyContract = KittyInterface(_address);
	}

	function _triggerCooldown(Zombie storage _zombie) internal {
		_zombie.readyTime = uint32(block.timestamp + cooldownTime);
	}

	function _isReady(Zombie storage _zombie) internal view returns (bool) {
		return (_zombie.readyTime <= block.timestamp);
	}

	function feedAndMultiply(
		uint _zombieId,
		uint _targetDna,
		string memory _species
	) internal onlyOwnerOf(_zombieId) {
		Zombie storage myZombie = zombies[_zombieId];
		require(_isReady(myZombie), "zombie is in cooldown");
		_targetDna = _targetDna % dnaModulus;
		uint newDna = (myZombie.dna + _targetDna) / 2;
		if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {
			newDna = newDna - (newDna % 100) + 99;
		}
		_createZombie("NoName", newDna);
		_triggerCooldown(myZombie);
	}

	function feedOnKitty(uint _zombieId, uint _kittyId) public {
		uint kittyDna;
		(, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
		feedAndMultiply(_zombieId, kittyDna, "kitty");
	}
}