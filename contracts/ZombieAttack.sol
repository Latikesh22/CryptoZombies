// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieHelper.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ZombieAttack is ZombieHelper {
	using SafeMath for uint;
	using SafeCast for uint;

	uint private randNonce = 0;
	uint private attackVictoryProbability = 70;

	function randMod(uint _modulus) internal returns (uint) {
		randNonce = randNonce.add(1);
		return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
	}

	function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
		Zombie storage myZombie = zombies[_zombieId];
		Zombie storage enemyZombie = zombies[_targetId];
		uint rand = randMod(100);
		if (rand <= attackVictoryProbability) {
			myZombie.winCount = SafeCast.toUint16(uint(myZombie.winCount).add(1));
			myZombie.level = SafeCast.toUint16(uint(myZombie.level).add(1));
			enemyZombie.lossCount = SafeCast.toUint16(uint(myZombie.lossCount).add(1));
			feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
		} else {
			myZombie.lossCount = SafeCast.toUint16(uint(myZombie.lossCount).add(1));
			enemyZombie.winCount = SafeCast.toUint16(uint(enemyZombie.winCount).add(1));
			_triggerCooldown(myZombie);
		}
	}
}