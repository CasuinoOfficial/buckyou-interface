module buckyou_interface_v2::config {

    //***********************
    //  Price Config
    //***********************

    public fun initial_price_in_sui(): u64 { 2_000_000_000 } // initial 2 SUI
    public fun sui_decimals(): u8 { 9 }
    public fun precision(): u128 { 1_000_000_000_000_000_000 }
    public fun precision_decimals(): u8 { 18 }
    public fun max_price_in_sui(): u64 { 30_000_000_000 } // 30 SUI
    public fun price_period(): u64 { 7_200_000 } // 2 hrs
    public fun price_increment(): u64 { 1_000_000_000 } // +1 SUI every 2 hrs

    //***********************
    //  Profile Config
    //***********************
    
    public fun max_referral_depth(): u64 { 50 }
    public fun score_threshold(): u64 { 20 }

    //***********************
    //  Ticket Config
    //***********************

    public fun ticket_total_shares(): u64 { 1_000 }
    public fun final_pool_shares(): u64 { 600 } // 60%
    public fun lootbox_pool_shares(): u64 { 200 } // 20%
    public fun direct_senior_shares(): u64 { 100 } // 10%
    public fun indirect_seniors_shares(): u64 { 100 } // 10%

    //***********************
    //  Final Config
    //***********************

    public fun final_total_shares(): u64 { 1_000 }
    public fun winner_shares(): u64 { 800 } // 80% to winners
    public fun dev_shares(): u64 { 100 } // 10% to dev
    public fun crew_winner_shares(): u64 { 10 } // 1% to crew winner
    public fun crew_others_shares(): u64 { 90 } // 9% to whole crew
    public fun final_winner_count(): u64 { 20 } // 20 final winners

    //***********************
    //  Raffle Config
    //***********************

    public fun raffle_winner_count(): u64 { 3 } // 3 winners every round

    //***********************
    //  Status Config
    //***********************

    public fun initial_countdown(): u64 { 72 * 60 * 60_000 } // 72 hrs
    public fun time_increment(): u64 { 45_000 } // 45 sec
    public fun end_time_hard_cap(): u64 { 20 * 60_000 } // 20 mins
    public fun raffle_period(): u64 { 2 * 60 * 60_000 } // 2 hrs
}