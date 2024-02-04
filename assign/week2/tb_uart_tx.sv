module sim(

    );

reg clk = 0, rst;
wire tx;

always begin
    #50000
    clk = ~clk;
end

initial begin
    rst = 0;
    #10
    rst = 1;
    #1000
    rst = 0;
end

main DUT(
    .clk(clk),
    .rst(rst),
    .tx(tx)
);

endmodule
