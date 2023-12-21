# ERC-721 The Hard Way

## Events

- [x] event Transfer(address indexed \_from, address indexed \_to, uint256 indexed \_tokenId);
- [x] event Approval(address indexed \_owner, address indexed \_approved, uint256 indexed \_tokenId);
- [x] event ApprovalForAll(address indexed \_owner, address indexed \_operator, bool \_approved);

## Methods

- [x] function balanceOf(address \_owner) external view returns (uint256);
- [x] function ownerOf(uint256 \_tokenId) external view returns (address);
- [x] function safeTransferFrom(address \_from, address \_to, uint256 \_tokenId, bytes data) external payable;
- [x] function safeTransferFrom(address \_from, address \_to, uint256 \_tokenId) external payable;
- [x] function transferFrom(address \_from, address \_to, uint256 \_tokenId) external payable;
- [x] function approve(address \_approved, uint256 \_tokenId) external payable;
- [x] function setApprovalForAll(address \_operator, bool \_approved) external;
- [x] function getApproved(uint256 \_tokenId) external view returns (address);
- [x] function isApprovedForAll(address \_owner, address \_operator) external view returns (bool);

- [x] function supportsInterface(bytes4 interfaceID) external view returns (bool); (from ERC165 – Optional)

- [x] function mint(address to,uint256 tokenId) external returns (uint256 tokenId); (not in specs)

## ERC-721-Receiver

- [x] function onERC721Received(address \_operator, address \_from, uint256 \_tokenId, bytes \_data) external returns(bytes4)

## Tests

Test cases can found at [humayunj/ERC-721-Yul-tests](https://github.com/humayunj/ERC-721-Yul-tests)

### Notes

Minting is not specified in EIP, so there's no standard for it.
