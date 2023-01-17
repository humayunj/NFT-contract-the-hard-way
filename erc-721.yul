object "NFT" {
    code{
        sstore(0x0,caller()) // contract owner
        datacopy(0,dataoffset("runtime"),datasize("runtime"))
        return(0x0,datasize("runtime"))
    }
    object "runtime"{
        code {
            // abi compatibilty
            switch shr(0xe0,calldataload(0))
            case 0x70a08231 {
                /// function balanceOf(address _owner) external view returns (uint256); 
                
                returnUint(balanceOf(calldataload(0x4)))
            }
            case 0x6352211e {
                /// function ownerOf(uint256 _tokenId) external view returns (address);
                
                returnUint(ownerOf(calldataload(0x4)))
            }

            case 0x01ffc9a7 {
                /// ERC-165
                /// function supportsInterface(bytes4 interfaceID) external view returns (bool);
                
                returnUint(supportsInterface(calldataload(0x4)))
            }
           
            case 0x081812fc{
                /// function getApproved(uint256 _tokenId) external view returns (address);
                returnUint(getApproved(calldataload(0x4)))
            }

            case 0x095ea7b3 {
                /// function approve(address _approved, uint256 _tokenId) external payable;
             
                approve(calldataload(0x4),calldataload(0x24))
                return (0,0)
            }
        
           
            case 0xa22cb465 {
                // /function setApprovalForAll(address _operator, bool _approved) external;
                setApprovalForAll(calldataload(0x4),iszero(iszero(calldataload(0x24))) /** I don't trust humans 0,0 */)
                return(0,0)
            }
            case 0xe985e9c5 {
                /// function isApprovedForAll(address _owner, address _operator) external view returns (bool);
                
                returnUint(isApprovedForAll(calldataload(0x4),calldataload(0x24))) 
                /// bruh! Trust me, return value would be bool
            }

            case 0x6a627842 {
                /// Non-EIP
                /// function mint(address to) public returns (uint256 tokenId)
                
                returnUint(mint(calldataload(0x4)))
            }

            default {
                revert (0,0)
            }

            //---------------------
            /** Methods */
            function balanceOf(owner) -> blnc {
                blnc := sload(offsetOwnerToBalance(owner))
            }
            function ownerOf(tokenId) -> owner {
                owner := sload(offsetTokenToAddress(tokenId))
            }

            function mint(to) -> tokenId {
                
                tokenId := counterIncreament()
                sstore(offsetTokenToAddress(tokenId),to)
                increamentBalance(to)
                // emit event
            }


            function supportsInterface(interface) -> supports {
                
                switch interface 
                case 0x80ac58cd {
                    supports := 1
                }
                case 0x01ffc9a7 {
                    supports := 1
                }
                default {
                    supports := 0
                }
                
            }

            function getApproved(tokenId) -> addr {
                require(iszero(eq(ownerOf(tokenId),0x0)))
                addr := sload(offsetTokenToApproved(tokenId))
            }

            function approve(addr,tokenId) {

                require(iszero(eq(ownerOf(tokenId),0x0)))

                
                require(_isCallerAuthorizedForToken(tokenId))
                
                sstore(offsetTokenToApproved(tokenId),addr)

            }


            function setApprovalForAll(operator,approved) {
                let owner := caller()
                require(iszero(eq(owner,0x0)))
                require(_isCallerAuthorizedForAll(owner))

                sstore(offsetApproveForAll(owner,operator),approved)
            }
            function isApprovedForAll(owner,operator) -> approved {
                approved := _isOperatorApprovedForAll(owner,operator)
            }

            function _isCallerAuthorizedForToken(tokenId) -> isAuthorized {
                let _caller := caller()
                let owner := ownerOf(tokenId)
                
                isAuthorized := or( or( eq(_caller,owner), eq(_isOperatorApprovedForAll(owner,_caller),1) ), eq(_caller,getApproved(tokenId)) )
            }
            function _isCallerAuthorizedForAll(owner) -> isAuthorized {
                let _caller := caller()
                
                isAuthorized := or(eq(_caller,owner), eq(_isOperatorApprovedForAll(owner,_caller),1))
            }

            function _isOperatorApprovedForAll(user,operator) -> approved {
                approved := sload( offsetApproveForAll(user,operator)) // approved = True if 1 or False if 0
            }
         

            
           

            //----------------------
            /** Storage Offsets */
            function offsetContractOwner() ->p {
                p := 0x0
            }
            function offsetTokenCounter() -> offset {
                offset := 0x20 // after the owner
            }
            
            function offsetTokenToAddress(tokenId) -> addr {
                addr := add(0x1000,tokenId)
            }
            function offsetOwnerToBalance(owner) -> offset {
                /**
                    offset = keccak(owner.concat(owner))
                    (Solidity docs inspired)
                */
                mstore(0,owner)
                mstore(0x20,owner)
                offset := keccak256(0,0x40)
            }
            function offsetTokenToApproved(tokenId) -> offset {
                /**
                    offset = keccak(tokenId.concat(ownerOf(tokenId)))
                */
                mstore(0,tokenId)
                mstore(0x20,ownerOf(tokenId)) 
                offset := keccak256(0,0x40) /// In Vitalik I trust, keys won't collide
            }
            function offsetApproveForAll(user,operator) ->offset{
                /**
                    offset = keccak(user.concat(operator))
                */
                

                mstore(0x0,user)
                mstore(0x20,operator)
                mstore(0x40,user)
                offset := keccak256(0,0x60)
            }
          
            
            //---------------------
            /** Utilities */
            function returnUint(value) {
                mstore(0,value)
                return(0,0x20)
            }
            function require(x) {
                if iszero(x) {
                    let magic := 0xCafeBabe // (0,0)
                    mstore(0,magic)
                    revert(0,0x20)
                }
            }
            function counterValue() -> val {
                val:= sload(0x20)
            }
            function counterIncreament() -> val {
                val:= sload(0x20)
                sstore(0x20,add(val,1))
            }
            function increamentBalance(owner){
                let offset := offsetOwnerToBalance(owner)
                sstore(offset,add(sload(offset),1))
            }
            
        }
    }
}