`timescale 1ns / 1ps

module ROM_D(
    input[8:0] a,
    output[31:0] spo
);

    reg[31:0] inst_data[0:511];

    initial	begin
        // $readmemh("rom.mem", inst_data);
        $readmemh("C:/Users/26822/Desktop/ZJU_Course_Resource/CA/Lab/lab1/lab1.srcs/sources_1/imports/core/rom.mem", inst_data);
        
    end

    assign spo = inst_data[a];

endmodule