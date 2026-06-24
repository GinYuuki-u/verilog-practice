# gen_vectors.py —— 生成 ALU 测试向量(全功能版)
import random

WIDTH = 16
MASK  = (1 << WIDTH) - 1          # 移位产生16个0，2^16-1 = 0xFFFF
SHIFT_MASK = (1 << (WIDTH.bit_length() - 1)) - 1  # 16→0xF,移位量只取低4位
# 等价于 $clog2(WIDTH) 的位数掩码;WIDTH=16 时 = 0xF

# operation code
ALU_ADD = 0
ALU_SUB = 1
ALU_AND = 2
ALU_OR  = 3
ALU_XOR = 4
ALU_NOT = 5
ALU_SLL = 6
ALU_SRL = 7

ALL_OPS = [ALU_ADD, ALU_SUB, ALU_AND, ALU_OR, ALU_XOR, ALU_NOT, ALU_SLL, ALU_SRL]

def golden(a, b, op, cin):
    """标准答案:精确模仿你的 ALU。返回 (result, carry)。"""
    carry = 0                     # 默认 carry=0(对应always_comb 的默认值)

    if op == ALU_ADD:
        full   = a + b + cin
        result = full & MASK
        carry  = (full >> WIDTH) & 1          # 第17位 = 进位
    elif op == ALU_SUB:
        full   = a - b - cin                  # 可能为负,& MASK 自动补码
        result = full & MASK
        carry  = 1 if(a >= b + cin) else 0

    elif op == ALU_AND:
        result = a & b
    elif op == ALU_OR:
        result = a | b 
    elif op == ALU_XOR:
        result = a ^ b 
    elif op == ALU_NOT:
        result = ~a & MASK
    elif op == ALU_SLL:
        result = (a << (b & SHIFT_MASK)) & MASK
    elif op == ALU_SRL:
        result = (a >> (b & SHIFT_MASK)) & MASK                
    else:
        result = 0

    return result, carry

def main():
    random.seed(42)
    cases = []

    # —— 手挑的边界用例(每种操作都塞几个危险的)——
    cases += [
        (0x0000, 0x0000, ALU_ADD, 0),
        (0xFFFF, 0x0001, ALU_ADD, 0),    # 进位
        (0x7FFF, 0x0001, ALU_ADD, 0),    # 正溢出
        (0x0005, 0x0003, ALU_SUB, 0),
        (0x0003, 0x0005, ALU_SUB, 0),    # 借位
        (0xABCD, 0x1234, ALU_AND, 0),
        (0xABCD, 0x1234, ALU_OR,  0),
        (0xFFFF, 0xFFFF, ALU_XOR, 0),    # 全1异或全1=0
        (0x00FF, 0x0000, ALU_NOT, 0),    # 取反
        (0x0001, 0x0004, ALU_SLL, 0),    # 左移4位
        (0x8000, 0x0004, ALU_SRL, 0),    # 右移4位
        (0x0001, 0x0014, ALU_SLL, 0),    # 移位量=0x14,截位后只移低4位(=4)!验证截位
    ]

    # —— 随机补一大批,每种操作都覆盖到 ——
    for _ in range(200):
        a   = random.randint(0, MASK)
        b   = random.randint(0, MASK)
        op  = random.choice(ALL_OPS)
        cin = random.randint(0, 1)
        cases.append((a, b, op, cin))

    # —— 写文件:每行  a b op cin exp_result exp_carry (全十六进制)——
    with open("vectors.hex", "w") as f:
        for (a, b, op, cin) in cases:
            res, carry = golden(a, b, op, cin)
            f.write(f"{a:04x} {b:04x} {op:x} {cin:x} {res:04x} {carry:x}\n")

    print(f"已生成 {len(cases)} 条向量 → vectors.hex")

if __name__ == "__main__":
    main()