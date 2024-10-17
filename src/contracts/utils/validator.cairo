#[starknet::interface]
trait IValidator<TContractState> {

    /// Returns the address of the CTF instance associated to the user.
    /// This can be called by anyone for any user.
    /// 
    /// ## Arguments
    /// - user: The address of the user.
    /// - k: The part index (in this case, should always be 1.)
    fn deployments(
        self: @TContractState, 
        user: starknet::ContractAddress, 
        k: u8
    ) -> starknet::ContractAddress;

    /// Returns whether the user has solved the CTF instance.
    /// This can be called by anyone for any user.
    /// 
    /// ## Arguments
    /// - user: The address of the user.
    /// - k: The part index (in this case, should always be 1.)
    fn test(
        self: @TContractState, 
        user: starknet::ContractAddress, 
        k: u8
    ) -> bool;

    /// Returns the contract name of the CTF instance.
    /// This can be called by anyone.
    /// 
    /// ## Arguments
    /// - k: The part index (in this case, should always be 1.)
    fn contract_name(self: @TContractState, k: u8) -> felt252;

    /// Deploys a CTF instance associated to the user.
    /// This is called by the user's account.
    /// 
    /// ## Arguments
    /// - k: The part index (in this case, should always be 1.)
    fn deploy(ref self: TContractState, k: u8);
}

#[starknet::contract]
mod Validator {

    use starknet::{
        ClassHash,
        ContractAddress,
        deploy_syscall,
        get_caller_address,
        storage::Map
    };

    use src::contracts::sphinx::{ 
        ISphinxDispatcher, 
        ISphinxDispatcherTrait 
    };

    #[storage]
    struct Storage {
        deployer_nonce: felt252, 
        sphinx_hash: ClassHash,
        sphinxes: Map<ContractAddress, ContractAddress>
    }

    #[constructor]
    fn constructor(ref self: ContractState, sphinx_hash: ClassHash) {
        self.sphinx_hash.write(sphinx_hash);
    }

    #[abi(embed_v0)]
    impl ValidatorImpl of super::IValidator<ContractState> {

        fn deployments(self: @ContractState, user: ContractAddress, k: u8) -> ContractAddress {
            assert(k == 1, 'Not in scope of quest');
            self.sphinxes.read(user)
        }

        fn test(self: @ContractState, user: ContractAddress, k: u8) -> bool {
            assert(k == 1, 'Not in scope of quest');

            let sphinx_address = self.sphinxes.read(user);
            assert(!sphinx_address.is_zero(), 'Not deployed');

            let sphinx = ISphinxDispatcher { 
                contract_address: sphinx_address 
            };

            sphinx.is_defeated()
        }

        fn contract_name(self: @ContractState, k: u8) -> felt252 {
            assert(k == 1, 'Not in scope of quest');
            'Sphinx'
        }

        fn deploy(ref self: ContractState, k: u8) {
            assert(k == 1, 'Not in scope of quest');

            let nonce = self.deployer_nonce.read();
            self.deployer_nonce.write(nonce + 1);

            let chamber_hash = self.sphinx_hash.read();

            let calldata = ArrayTrait::new();
            
            let (sphinx_address, _) = deploy_syscall(
                chamber_hash,
                nonce, 
                calldata.span(), 
                false
            ).unwrap();

            self.sphinxes.write(get_caller_address(), sphinx_address);
        }
    }

}