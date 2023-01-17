# ERC-721 The Hard Way

## Why?

As James said in the intro of The End of the F\*\*\*ing World. **_"I wanted to make myself feel something."_**

## Events

- [ ] event Transfer(address indexed \_from, address indexed \_to, uint256 indexed \_tokenId);
- [ ] event Approval(address indexed \_owner, address indexed \_approved, uint256 indexed \_tokenId);
- [ ] event ApprovalForAll(address indexed \_owner, address indexed \_operator, bool \_approved);

## Methods

- [x] function balanceOf(address \_owner) external view returns (uint256);
- [x] function ownerOf(uint256 \_tokenId) external view returns (address);
- [ ] function safeTransferFrom(address \_from, address \_to, uint256 \_tokenId, bytes data) external payable;
- [x] function safeTransferFrom(address \_from, address \_to, uint256 \_tokenId) external payable;
- [x] function transferFrom(address \_from, address \_to, uint256 \_tokenId) external payable;
- [x] function approve(address \_approved, uint256 \_tokenId) external payable;
- [x] function setApprovalForAll(address \_operator, bool \_approved) external;
- [x] function getApproved(uint256 \_tokenId) external view returns (address);
- [x] function isApprovedForAll(address \_owner, address \_operator) external view returns (bool);
- [x] function supportsInterface(bytes4 interfaceID) external view returns (bool); (from ERC165 – Optional)

- [x] function mint(address to) public returns (uint256 tokenId)

## ERC-721-Receiver

- [x] function onERC721Received(address \_operator, address \_from, uint256 \_tokenId, bytes \_data) external returns(bytes4)

### Notes

Minting is not specified in EIP, so there's no standard for it.
Encoding of dynamic types slightly differs from static types ( to be used in safeTransferFrom with bytes )
