`timescale 1ns/1ps

module tb_comp #(
parameter int size=32);

    logic   [size-1:0] a, b;
    logic   eq, lt, gt;

    // Тестируемая схема
    
    comp #(.size(size)) dut(.a(a), .b(b), .eq(eq), .lt(lt), .gt(gt));
    
    // Тут будут отсчеты времени (time - это 64-bit unsigned типв SystemVerilog)
    realtime t_start;
    realtime t_valid;


    // Набор данных для тестирования
    localparam int NTEST = 12;
    logic [size-1:0] a_vec [NTEST];
    logic [size-1:0] b_vec [NTEST];

    initial begin
        a_vec[0] = {size{1'b0}};              b_vec[0] = {size{1'b0}};
        a_vec[1] = {size{1'b0}};              b_vec[1] = {{size-1{1'b0}}, 1'b1};
        a_vec[2] = {{size-1{1'b0}}, 1'b1};    b_vec[2] = {size{1'b0}};
        a_vec[3] = {size{1'b1}};              b_vec[3] = {size{1'b0}};
        a_vec[4] = {size{1'b0}};              b_vec[4] = {size{1'b1}};
        a_vec[5] = {1'b0, {{size-1{1'b1}}}};  b_vec[5] = {1'b1, {{size-1{1'b0}}}};
        a_vec[6] = {1'b1, {{size-1{1'b0}}}};  b_vec[6] = {1'b0, {{size-1{1'b1}}}};
        a_vec[7] = {{size-8{1'b0}}, 8'h21};   b_vec[7] = {{size-8{1'b0}}, 8'h21};
        a_vec[8] = {size{1'b0}};              b_vec[8] = {{size-1{1'b0}}, 1'b1};
        a_vec[9] = {{size-32{1'b0}}, 32'hDEAD_BEEF};  b_vec[9] = {{size-32{1'b0}}, 32'hDEAD_BEEE};
        a_vec[10] = {{size-20{1'b0}}, 20'd654321};    b_vec[10] = {{size-20{1'b0}}, 20'd123456};
        a_vec[11] = {{size-32{1'b0}}, 32'h0123_4567}; b_vec[11] = {{size-32{1'b0}}, 32'h89AB_CDEF};
    end

    integer i;

    initial begin
        // Присвоим начальные значения и подождем 100 единиц времени
        a = '0;
        b = '0;
        #100;

        // Будем поочередно выбирать входные значения и ждать 100 единиц времени
        for (i = 0; i < NTEST; i++) begin
            a = a_vec[i];
            b = b_vec[i];
            t_start = $realtime;

            // Ждём появления корректного результата и фиксируем время его появления
            wait (eq === (a_vec[i] == b_vec[i]) &&
                  lt === (a_vec[i] <  b_vec[i]) &&
                  gt === (a_vec[i] >  b_vec[i]) );
            t_valid = $realtime;
            
            // Ждем еще 20 единиц времени, печатаем результат и запускаем следующий тест
            #20;
            $display("t=%0t | test=%0d | a=%h b=%h | eq=%0d lt=%0d gt=%0d | delay=%0.3f", $time, i, a, b, eq, lt, gt, t_valid-t_start);
        end

        $display("Simulation finished.");
        $finish;
    end

endmodule
