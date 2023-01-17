# ERC-721 Checklist

## Events

- [ ] event Transfer(address indexed \_from, address indexed \_to, uint256 indexed \_tokenId);
- [ ] event Approval(address indexed \_owner, address indexed \_approved, uint256 indexed \_tokenId);
- [ ] event ApprovalForAll(address indexed \_owner, address indexed \_operator, bool \_approved);

## Methods

- [x] function balanceOf(address \_owner) external view returns (uint256);
- [x] function ownerOf(uint256 \_tokenId) external view returns (address);
- [ ] function safeTransferFrom(address \_from, address \_to, uint256 \_tokenId, bytes data) external payable;
- [ ] function safeTransferFrom(address \_from, address \_to, uint256 \_tokenId) external payable;
- [ ] function transferFrom(address \_from, address \_to, uint256 \_tokenId) external payable;
- [ ] function approve(address \_approved, uint256 \_tokenId) external payable;
- [x] function setApprovalForAll(address \_operator, bool \_approved) external; [ToTest]
- [x] function getApproved(uint256 \_tokenId) external view returns (address);
- [ ] function isApprovedForAll(address \_owner, address \_operator) external view returns (bool); [ToTest]
- [x] function supportsInterface(bytes4 interfaceID) external view returns (bool); (from ERC165 – Optional)

- [x] function mint(address to) public returns (uint256 tokenId)

## Notes

Minting and burning is not specified in EIP
