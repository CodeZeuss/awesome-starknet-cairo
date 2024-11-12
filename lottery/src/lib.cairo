#[starknet::interface]
pub trait ILottery<TContractState> {
    fn increase_balance(ref self: TContractState, amount: felt252);
    fn get_balance(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod Lottery {
    #[storage]
    struct Storage {
        balance: felt252, 
    }

    #[derive(Drop, Copy, Serde)]
    pub enum Age {
        BelowEighteen,
        AboveEighteen,
        AboveFifty
    }

    #[abi(embed_v0)]
    impl LotteryImpl of super::ILottery<ContractState> {
        fn increase_balance(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            self.balance.write(self.balance.read() + amount);
        }

        fn get_balance(self: @ContractState) -> felt252 {
            self.balance.read()
        }
    }
}
