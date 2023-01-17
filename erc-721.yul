object "NFT" {
    code{
        sstore(0x0,caller()) // contract owner
        datacopy(0,dataoffset("runtime"),datasize("runtime"))
        return(0x0,datasize("runtime"))
    }
    object "runtime"{
        code {
            // abi compatibilty
            switch shr(0xe0,calldataload(0x0))
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

            case 0x23b872dd {
                // function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
                transferFrom(calldataload(0x4),calldataload(0x24),calldataload(0x44))
            }

            case 0x42842e0e {
                // function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
                safeTransferFromWithData(calldataload(0x4),calldataload(0x24),calldataload(0x44),0x0)
            }
            case 0xb88d4fde {
                // function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
                // p.s there's another, quicker way too
                let numberOfBytes := calldataload(0x64)
                // let length := sub(calldatasize(),0x64)
                calldatacopy(0x84,0x84,numberOfBytes)
                safeTransferFromWithData(calldataload(0x4),calldataload(0x24),calldataload(0x44),numberOfBytes)
            }

            default {
                mstore(0,0x404)
                revert(0,0x20)                
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
                balanceIncreament(to)
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

            function transferFrom( from,  to,  tokenId) {
                require(iszero(eq(to,0x0))) // can't transfer to 0 address
                let owner:= ownerOf(tokenId)
                require(iszero(eq(owner,0x0))) // valid nft
                require(_isCallerAuthorizedForToken(tokenId))
                _transferOwnership(owner,to,tokenId)
            }

            // @read-plz: the data must be placed at 0x64 to data Length         
            function safeTransferFromWithData( from,  to,  tokenId,datalength)  {
                require(iszero(eq(to,0x0)))
                let owner := ownerOf(tokenId)
                require(iszero(eq(owner,0x0))) // valid nft
                require(_isCallerAuthorizedForToken(tokenId))

                _transferOwnership(owner,to,tokenId)
                
                switch _isContract(to) 
                    case 0 {
                        // happy ever after
                    }
                    case 1 {
                        // eternal pain
                        _callOnRecevied(from,owner,to,tokenId,datalength)
                    }
                
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
                    let pickUpLine := 0xCafeBabe // (0,0)
                    mstore(0,pickUpLine)
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
            function balanceIncreament(owner){
                let offset := offsetOwnerToBalance(owner)
                sstore(offset,add(sload(offset),1))
            }
            function balanceDecreament(owner){
                let offset := offsetOwnerToBalance(owner)
                sstore(offset,sub(sload(offset),1))
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
            function _isContract(addr) -> flag {
                flag := gt(extcodesize(addr),0) 
            }
            function _transferOwnership(from,to,tokenId) {
                sstore(offsetTokenToApproved(tokenId),0x0) // remove approved
                sstore(offsetTokenToAddress(tokenId),to) // change ownership
                
                balanceDecreament(from) // decrease prev owner blnc
                balanceIncreament(to) // increase new owner balance
            }

            // @notice-plz: the data must be placed at 0x64 to dataLength
            function _callOnRecevied(from,owner,to,tokenId,dataLength) {
                //  function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
                let magic := 0x150b7a02

                mstore(0x0,shl(0xe0,magic)) // append 32 bits, I know! -_-
                let testb:= mload(0x0)
               
                mstore(0x4,from)
                mstore(0x24,owner)
                mstore(0x44,tokenId)
                mstore(0x64,dataLength)
                let argsLength := add(0x84,dataLength)
                let success := call(gas(),to,0x0,0x0,argsLength,0,0)
                require(eq(success,1))

                returndatacopy(0,0,0x20) // just single slot

                require(eq(mload(0x0),magic))
                
            }
        }
    }
}