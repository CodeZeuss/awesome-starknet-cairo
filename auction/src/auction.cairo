#[starknet::contract]
mod Auction {
    use starknet::event::EventEmitter;
use crate::interfaces::iauction::IAuction;
    use crate::interfaces::ierc721::{IERC721Dispatcher, IERC721DispatcherTrait};
    use starknet::{ContractAddress, get_caller_address, get_contract_address, get_block_timestamp};
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess, Map, StoragePathEntry};

    const DAY_IN_SECONDS: u64 = 86400;
    const SEVEN_DAYS_IN_SECONDS: u64 = 7 * DAY_IN_SECONDS;

    #[storage]
    struct Storage {
        nft: ContractAddress,
        nft_id: u256,
        seller: ContractAddress,
        end_at: u256,
        started: bool,
        ended: bool,
        highest_bidder: ContractAddress,
        highest_bid: u256,
        bids: Map<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Start: Start,
        Bid: Bid,
        Withdraw: Withdraw,
        End: End
    }

    #[derive(Drop, starknet::Event)]
    struct Start {}

    #[derive(Drop, starknet::Event)]
    struct Bid {
        sender: ContractAddress,
        amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct Withdraw {
        bidder: ContractAddress,
        amount: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct End {
        winner: ContractAddress,
        amount: u256
    }

    #[constructor]
    fn constructor(ref self: ContractState, nft_address: ContractAddress, nft_id: u256, starting_bid: u256) {
        let caller = get_caller_address();
        self.nft.write(nft_address);
        self.nft_id.write(nft_id);
        self.seller.write(caller);
        self.highest_bid.write(starting_bid);
    }

    #[abi(embed_v0)]
    impl AuctionImpl of IAuction<ContractState> {
        fn start(ref self: ContractState) {
            let caller = get_caller_address();
            let this_contract = get_contract_address();

            assert(self.started.read() == false, 'Already started');
            assert(caller == self.seller.read(), 'Not Seller');

            let nft = IERC721Dispatcher { contract_address: self.nft.read() };
            nft.transfer_from(caller, this_contract, self.nft_id.read());

            self.started.write(true);
            self.end_at.write((get_block_timestamp() + SEVEN_DAYS_IN_SECONDS).try_into().unwrap());

            self.emit(Start{});
        }

        fn bid(ref self: ContractState, amount: u256) {

        }

        fn withdraw(ref self: ContractState) {

        }

        fn end(ref self: ContractState) {

        }

        fn nft(self: @ContractState) -> ContractAddress {

        }

        fn nft_id(self: @ContractState) -> u256 {

        }

        fn seller(self: @ContractState) -> ContractAddress {

        }

        fn end_at(self: @ContractState) -> u256 {

        }

        fn started(self: @ContractState) -> bool {

        }

        fn ended(self: @ContractState) -> bool {

        }

        fn highest_bidder(self: @ContractState) -> ContractAddress {

        }

        fn highest_bid(self: @ContractState) -> u256 {

        }
    }
}
