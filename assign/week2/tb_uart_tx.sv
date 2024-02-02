module sim(

    );

reg clk = 0, rst;
wire tx;

always begin
    #500000
    clk = ~clk;
end

initial begin
    rst = 0;
    #100
    rst = 1;
    #10000
    rst = 0;
end

main DUT(
    .clk(clk),
    .rst(rst),
    .tx(tx)
);

endmodule
