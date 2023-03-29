// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZombieAttack.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ZombieOwnership is ZombieAttack, IERC721 {
	using SafeMath for uint;
	using SafeCast for uint;

	mapping(uint => address) private zombieApprovals;

	modifier transferAuthorized(uint _tokenId) {
		require(
			zombieToOwner[_tokenId] == msg.sender || zombieApprovals[_tokenId] == msg.sender,
			"unauthorized operation"
		);
		_;
	}

	function balanceOf(address _owner) external view override returns (uint balance) {
		return ownerZombieCount[_owner];
	}

	function ownerOf(uint _tokenId) external view override returns (address owner) {
		return zombieToOwner[_tokenId];
	}

	function _transfer(
		address _from,
		address _to,
		uint _tokenId
	) private {
		ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
		ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
		zombieToOwner[_tokenId] = _to;
		emit Transfer(_from, _to, _tokenId);
	}

	function safeTransferFrom(
		address _from,
		address _to,
		uint _tokenId
	) external override transferAuthorized(_tokenId) {
		_transfer(_from, _to, _tokenId);
	}

	function safeTransferFrom(
		address _from,
		address _to,
		uint _tokenId,
		bytes calldata _data
	) external override transferAuthorized(_tokenId) {
		_transfer(_from, _to, _tokenId);
	}

	function transferFrom(
		address _from,
		address _to,
		uint _tokenId
	) external override transferAuthorized(_tokenId) {
		_transfer(_from, _to, _tokenId);
	}

	function approve(address _to, uint _tokenId) external override onlyOwnerOf(_tokenId) {
		zombieApprovals[_tokenId] = _to;
		emit Approval(msg.sender, _to, _tokenId);
	}

	function getApproved(uint _tokenId) external view override returns (address operator) {
		return zombieApprovals[_tokenId];
	}

	function setApprovalForAll(address operator, bool _approved) external override {
		// TODO add operator support
	}

	function isApprovedForAll(address _owner, address _operator) external pure override returns (bool) {
		return false;
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
		return false;
	}
}