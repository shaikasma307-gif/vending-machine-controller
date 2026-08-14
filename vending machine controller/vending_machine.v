module vending_machine (
    input  wire       clk,
    input  wire       reset,
    input  wire [1:0] coin,       // 01 = ₹5, 10 = ₹10
    input  wire       select_item,
    output reg        dispense,
    output reg [4:0]  change
);

    parameter ITEM_PRICE = 15;

    reg [4:0] balance;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            balance  <= 0;
            dispense <= 0;
            change   <= 0;
        end
        else begin
            dispense <= 0;
            change   <= 0;

            // Insert coin
            case (coin)
                2'b01: balance <= balance + 5;
                2'b10: balance <= balance + 10;
                default: balance <= balance;
            endcase

            // Select item
            if (select_item) begin
                if ((balance >= ITEM_PRICE) ||
                    ((coin == 2'b01) && (balance + 5 >= ITEM_PRICE)) ||
                    ((coin == 2'b10) && (balance + 10 >= ITEM_PRICE))) begin

                    dispense <= 1;

                    if ((balance + 5 >= ITEM_PRICE) && (coin == 2'b01))
                        change <= balance + 5 - ITEM_PRICE;
                    else if ((balance + 10 >= ITEM_PRICE) && (coin == 2'b10))
                        change <= balance + 10 - ITEM_PRICE;
                    else
                        change <= balance - ITEM_PRICE;

                    balance <= 0;
                end
            end
        end
    end

endmodule