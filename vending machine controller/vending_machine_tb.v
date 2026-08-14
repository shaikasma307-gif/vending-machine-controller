`timescale 1ns/1ps

module vending_machine_tb;

    reg clk;
    reg reset;
    reg [1:0] coin;
    reg select_item;

    wire dispense;
    wire [4:0] change;

    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .select_item(select_item),
        .dispense(dispense),
        .change(change)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        coin = 2'b00;
        select_item = 0;

        #10;
        reset = 0;

        // Insert ₹5
        #10;
        coin = 2'b01;

        // Insert ₹10
        #10;
        coin = 2'b10;

        // Select item
        #10;
        coin = 2'b00;
        select_item = 1;

        #10;
        select_item = 0;

        // Insert ₹10 + ₹10
        #10;
        coin = 2'b10;

        #10;
        coin = 2'b10;

        // Select item
        #10;
        coin = 2'b00;
        select_item = 1;

        #10;
        select_item = 0;

        #20;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | Coin=%b | Select=%b | Balance=%0d | Dispense=%b | Change=%0d",
                 $time, coin, select_item, uut.balance, dispense, change);
    end

endmodule