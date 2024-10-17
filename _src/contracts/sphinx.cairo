#[starknet::interface]
trait ISphinx<TContractState> {
    fn deal_damage(ref self: TContractState, amount: u32);
    fn is_defeated(self: @TContractState) -> bool;
}

#[starknet::contract]
mod Sphinx {

    #[storage]
    struct Storage {
        damage_received: u32
    }

    #[abi(embed_v0)]
    impl Sphinx_Impl of super::ISphinx<ContractState> {

        fn deal_damage(ref self: ContractState, amount: u32) {
            let old_damage = self.damage_received.read();
            self.damage_received.write(old_damage + amount);
        }
        
        fn is_defeated(self: @ContractState) -> bool {
            return self.damage_received.read() >= 100;
        }
    }

}