module buckyou_interface_v2::periphery {

    use std::vector;
    use std::option::Option;
    use sui::coin::{Self, Coin};
    use sui::tx_context::{Self, TxContext};
    use sui::clock::Clock;
    use sui::transfer;
    use buckyou_interface_v2::math::mul_and_div;
    use buckyou_interface_v2::oracle::{Self, Oracle};
    use buckyou_interface_v2::final::FinalPool;
    use buckyou_interface_v2::lootbox::LootboxPool;
    use buckyou_interface_v2::game_status::{Self as gm, GameStatus};
    use buckyou_interface_v2::profile_manager::ProfileManager;
    use buckyou_interface_v2::trove_manager::{Self as tm, TroveManager};
    use buckyou_interface_v2::listing::CoinTypeWhitelist;
    use buckyou_interface_v2::ticket;

    public fun claim_all_and_buy_to<T>(
        clock: &Clock,
        whitelist: &CoinTypeWhitelist,
        oracle: &Oracle,
        game_status: &mut GameStatus,
        profile_manager: &mut ProfileManager,
        trove_manager: &mut TroveManager,
        final_pool: &mut FinalPool,
        lootbox_pool: &mut LootboxPool,
        referrer_opt: Option<address>,
        on_behalf_of: address,
        to: address,
        ctx: &mut TxContext,
    ) {
        let buyer = tx_context::sender(ctx);
        let cliff_time = gm::cliff_time(game_status);
        let ticket_price = mul_and_div(
            oracle::ticket_price<T>(oracle, clock, cliff_time),
            7, 10
        );
        let trove_value = tm::get_trove_value<T>(trove_manager, buyer);
        let count = trove_value / ticket_price;
        if (count > 0) {
            let zero_coin = coin::zero<T>(ctx);
            let tickets = ticket::buy<T>(
                clock,
                whitelist,
                oracle,
                game_status,
                profile_manager,
                trove_manager,
                final_pool,
                lootbox_pool,
                &mut zero_coin,
                count,
                referrer_opt,
                on_behalf_of,
                ctx,
            );
            coin::destroy_zero(zero_coin);
            while (!vector::is_empty(&tickets)) {
                transfer::public_transfer(
                    vector::pop_back(&mut tickets),
                    to,
                );
            };
            vector::destroy_empty(tickets);
        };
    }

    public fun claim_all_to<T>(
        trove_manager: &mut TroveManager,
        to: address,
        ctx: &mut TxContext,
    ) {
        let reward = tm::take_all_from_trove<T>(
            trove_manager, ctx,
        );
        if (coin::value(&reward) > 0) {
            transfer::public_transfer(reward, to);
        } else {
            coin::destroy_zero(reward);
        };
    }

    public fun buy_to<T>(
        clock: &Clock,
        whitelist: &CoinTypeWhitelist,
        oracle: &Oracle,
        game_status: &mut GameStatus,
        profile_manager: &mut ProfileManager,
        trove_manager: &mut TroveManager,
        final_pool: &mut FinalPool,
        lootbox_pool: &mut LootboxPool,
        coin: &mut Coin<T>, // if use zero coin then claim from trove and buy
        count: u64,
        referrer_opt: Option<address>,
        on_behalf_of: address,
        to: address,
        ctx: &mut TxContext,
    ) {
        let tickets = ticket::buy<T>(
            clock,
            whitelist,
            oracle,
            game_status,
            profile_manager,
            trove_manager,
            final_pool,
            lootbox_pool,
            coin,
            count,
            referrer_opt,
            on_behalf_of,
            ctx,
        );
        while (!vector::is_empty(&tickets)) {
            transfer::public_transfer(
                vector::pop_back(&mut tickets),
                to,
            );
        };
        vector::destroy_empty(tickets);
    }
}