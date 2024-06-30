module buckyou_interface_v2::splitter {
    
    use std::vector as vec;
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::balance::{Self, Balance};
    use sui::tx_context::TxContext;
    use buckyou_interface_v2::config;
    use buckyou_interface_v2::math::mul_and_div;

    //***********************
    //  Public Functions
    //***********************

    public fun split_the_coin<T>(
        coin: Coin<T>,
        ctx: &mut TxContext,
    ): (Coin<T>, Coin<T>, Coin<T>, Coin<T>) {
        let coin_value = coin::value(&coin);
        let coin_to_final = coin::split(
            &mut coin,
            mul_and_div(
                coin_value, config::final_pool_shares(), config::ticket_total_shares(),
            ),
            ctx,
        );
        let coin_to_lootbox = coin::split(
            &mut coin,
            mul_and_div(
                coin_value, config::lootbox_pool_shares(), config::ticket_total_shares(),
            ),
            ctx,
        );
        let coin_to_direct_senior = coin::split(
            &mut coin,
            mul_and_div(
                coin_value, config::direct_senior_shares(), config::ticket_total_shares(),
            ),
            ctx,
        );
        let coin_to_indirect_seniors = move coin;
        (
            coin_to_final,
            coin_to_lootbox,
            coin_to_direct_senior,
            coin_to_indirect_seniors,
        )
    }

    public fun split_final_pool<T>(
        pool: &mut Balance<T>,
        ctx: &mut TxContext,
    ): (Coin<T>, Coin<T>, Coin<T>, Coin<T>) {
        let balance_value = balance::value(pool);
        let coin_to_winners = coin::take(
            pool,
            mul_and_div(balance_value, config::winner_shares(), config::final_total_shares()),
            ctx,
        );
        let coin_to_dev = coin::take(
            pool,
            mul_and_div(balance_value, config::dev_shares(), config::final_total_shares()),
            ctx,
        );
        let coin_to_crew_winner = coin::take(
            pool,
            mul_and_div(balance_value, config::crew_winner_shares(), config::final_pool_shares()),
            ctx,
        );
        let coin_to_crew_others = coin::from_balance(
            balance::withdraw_all(pool), ctx,
        );
        (coin_to_winners, coin_to_dev, coin_to_crew_winner, coin_to_crew_others)
    }

    public fun divide_coin_to<T>(
        coin: Coin<T>,
        recipients: vector<address>,
        ctx: &mut TxContext,
    ) {
        let length = vec::length(&recipients);
        let coins = coin::divide_into_n(&mut coin, length, ctx);
        vec::push_back(&mut coins, coin);
        while (!vec::is_empty(&coins)) {
            let c = vec::pop_back(&mut coins);
            let recipient = vec::pop_back(&mut recipients);
            transfer::public_transfer(c, recipient);
        };
        vec::destroy_empty(coins);
    }
}
