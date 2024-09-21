import tkinter as tk

# 定义指令与对应的二进制值的映射
INSTRUCTION_MAPPING = {
    "RWS": "0001",
    "RDS": "0010",
    "SMS": "0011",
    "WRM": "0100",
    "WMS": "0101",
    "SO1": "0110",
    "SO2": "0111",
    "SIC": "1000",
    "SCS": "1001",
    "W"  : "1010",
    "MMM": "1011",
    "GBI": "1100",
    "S"  : "0000"
}

def convert_instruction_to_binary(instruction):
    if "//" in instruction:
        return "//"

    if "RWS" in instruction:
        # 提取数字部分并将其转换为不同位宽的二进制字符串
        numbers = [int(num) for num in instruction.split()[1:6]]
        binary_num_1 = "".join(format(numbers[0], "024b"))  # 24位二进制
        binary_num_2 = "".join(format(numbers[1], "010b"))  # 10位二进制
        binary_num_3 = "".join(format(numbers[2], "06b"))   # 6位二进制
        binary_num_4 = "".join(format(numbers[3], "016b"))  # 16位二进制
        binary_num_5 = "".join(format(numbers[4], "04b"))   # 4位二进制
        # 连接在一起
        combined_binary_num = "0001" + binary_num_5 + binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1
        return combined_binary_num
    elif "RDS" in instruction:
        # 提取数字部分并将其转换为不同位宽的二进制字符串
        numbers = [int(num) for num in instruction.split()[1:6]]
        binary_num_1 = "".join(format(numbers[0], "018b"))  # 18位二进制
        binary_num_2 = "".join(format(numbers[1], "016b"))  # 16位二进制
        binary_num_3 = "".join(format(numbers[2], "06b"))  # 6位二进制
        binary_num_4 = "".join(format(numbers[3], "016b"))  # 16位二进制
        binary_num_5 = "".join(format(numbers[4], "04b"))  # 4位二进制
        # 连接在一起
        combined_binary_num = "0010" + binary_num_5 + binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1
        return combined_binary_num
    elif "SMS" in instruction:
        # 提取数字部分并将其转换为不同位宽的二进制字符串
        numbers = [int(num) for num in instruction.split()[1:5]]
        binary_num_1 = "".join(format(numbers[0], "015b"))  # 15位二进制
        binary_num_2 = "".join(format(numbers[1], "015b"))  # 15位二进制
        binary_num_3 = "".join(format(numbers[2], "015b"))  # 15位二进制
        binary_num_4 = "".join(format(numbers[3], "015b"))  # 15位二进制
        # 连接在一起
        combined_binary_num = "0011" + binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1
        return combined_binary_num
    elif "WRM" in instruction:
        # 提取数字部分并将其转换为二进制
        numbers = [int(num) for num in instruction.split()[1:6]]
        binary_num_1 = "".join(format(numbers[0], "01b"))  # 1位二进制
        binary_num_2 = "".join(format(numbers[1], "01b"))  # 1位二进制
        binary_num_3 = "".join(format(numbers[2], "01b"))  # 1位二进制
        binary_num_4 = "".join(format(numbers[3], "01b"))  # 1位二进制
        binary_num_5 = "".join(format(numbers[4], "08b"))  # 8位二进制
        # 连接在一起
        combined_binary_num = "0100" + (binary_num_5 + binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1).rjust(60, "0")
        return combined_binary_num
    elif "WMS" in instruction:
        return ("0101").ljust(64, "0")
    elif "SO1" in instruction:
        # 提取数字部分并将其转换为二进制
        numbers = [int(num) for num in instruction.split()[1:11]]
        binary_num_1  = "".join(format(numbers[0], "04b"))  # 4位二进制
        binary_num_2  = "".join(format(numbers[1], "06b"))  # 6位二进制
        binary_num_3  = "".join(format(numbers[2], "07b"))  # 7位二进制
        binary_num_4  = "".join(format(numbers[3], "05b"))  # 5位二进制
        binary_num_5  = "".join(format(numbers[4], "05b"))  # 5位二进制
        binary_num_6  = "".join(format(numbers[5], "05b"))  # 5位二进制
        binary_num_7  = "".join(format(numbers[6], "06b"))  # 6位二进制
        binary_num_8  = "".join(format(numbers[7], "06b"))  # 6位二进制
        binary_num_9  = "".join(format(numbers[8], "06b"))  # 6位二进制
        binary_num_10 = "".join(format(numbers[9], "06b"))  # 6位二进制
        # 连接在一起
        combined_binary_num = "0110" + (binary_num_10 + binary_num_9 + binary_num_8 + binary_num_7 + binary_num_6 +
                               binary_num_5 + binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1).rjust(60,"0")
        return combined_binary_num
    elif "SO2" in instruction:
        # 提取数字部分并将其转换为二进制
        numbers = [int(num) for num in instruction.split()[1:3]]
        binary_num_1 = "".join(format(numbers[0], "04b"))  # 4位二进制
        binary_num_2 = "".join(format(numbers[1], "04b"))  # 4位二进制
        # 连接在一起
        combined_binary_num = "0111" + (binary_num_2 + binary_num_1).rjust(60,"0")
        return combined_binary_num
    elif "SIC" in instruction:
        # 提取数字部分并将其转换为二进制
        numbers = [int(num) for num in instruction.split()[1:5]]
        binary_num_1 = "".join(format(numbers[0], "016b"))  # 16位二进制
        binary_num_2 = "".join(format(numbers[1], "016b"))  # 16位二进制
        binary_num_3 = "".join(format(numbers[2], "016b"))  # 16位二进制
        binary_num_4 = "".join(format(numbers[3], "04b"))   # 4位二进制
        # 连接在一起
        combined_binary_num = "1000" + (binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1).rjust(60,"0")
        return combined_binary_num
    elif "SCS" in instruction:
        # 提取数字部分并将其转换为二进制
        numbers = [int(num) for num in instruction.split()[1:17]]
        binary_num_1 = "".join(format(numbers[0], "01b"))  # 1位二进制
        binary_num_2 = "".join(format(numbers[1], "01b"))  # 1位二进制
        binary_num_3 = "".join(format(numbers[2], "01b"))  # 1位二进制
        binary_num_4 = "".join(format(numbers[3], "01b"))  # 1位二进制
        binary_num_5 = "".join(format(numbers[4], "01b"))  # 1位二进制
        binary_num_6 = "".join(format(numbers[5], "01b"))  # 1位二进制
        binary_num_7 = "".join(format(numbers[6], "01b"))  # 1位二进制
        binary_num_8 = "".join(format(numbers[7], "01b"))  # 1位二进制
        binary_num_9 = "".join(format(numbers[8], "01b"))  # 1位二进制
        binary_num_10= "".join(format(numbers[9], "01b"))  # 1位二进制
        binary_num_11= "".join(format(numbers[10], "01b"))  # 1位二进制
        binary_num_12= "".join(format(numbers[11], "01b"))  # 1位二进制
        binary_num_13= "".join(format(numbers[12], "01b"))  # 1位二进制
        binary_num_14= "".join(format(numbers[13], "01b"))  # 1位二进制
        binary_num_15= "".join(format(numbers[14], "01b"))  # 1位二进制
        binary_num_16= "".join(format(numbers[15], "01b"))  # 1位二进制
        # 连接在一起
        combined_binary_num = "1001" + (binary_num_16 + binary_num_15 + binary_num_14 + binary_num_13 + binary_num_12 + binary_num_11 + binary_num_10 + binary_num_9 + binary_num_8 + binary_num_7 + binary_num_6 + binary_num_5 + binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1).rjust(60,"0")
        return combined_binary_num
    elif "W" in instruction:
        # 提取数字部分并将其转换为二进制
        numbers = [int(num) for num in instruction.split()[1:2]]
        # binary_num_1 = "".join(format(num, "032b") for num in numbers)  # 32位二进制
        binary_num_1 = format(numbers[0], "032b")  # 32位二进制
        # 连接在一起
        combined_binary_num = "1010" + (binary_num_1).rjust(60,"0")
        return combined_binary_num
    elif "MMM" in instruction:
        # 提取数字部分并将其转换为二进制
        numbers = [int(num) for num in instruction.split()[1:9]]
        binary_num_1 = "".join(format(numbers[0], "010b"))  # 10位二进制
        binary_num_2 = "".join(format(numbers[1], "010b"))  # 10位二进制
        binary_num_3 = "".join(format(numbers[2], "010b"))  # 10位二进制
        binary_num_4 = "".join(format(numbers[3], "010b"))  # 10位二进制
        binary_num_5 = "".join(format(numbers[4], "02b"))   # 2位二进制
        binary_num_6 = "".join(format(numbers[5], "06b"))   # 6位二进制
        binary_num_7 = "".join(format(numbers[6], "06b"))   # 6位二进制
        binary_num_8 = "".join(format(numbers[7], "06b"))   # 6位二进制
        # 连接在一起
        combined_binary_num = "1011" + binary_num_8 + binary_num_7 + binary_num_6 + binary_num_5 + binary_num_4 + binary_num_3 + binary_num_2 + binary_num_1
        return combined_binary_num
    elif "S" in instruction:
        return ("0000").ljust(64,"0")
    else:
        # 填充到64位
        return INSTRUCTION_MAPPING.get(instruction, "Unknown").ljust(64,"0")

def save_to_txt(data, filename):
    # 补全指令条数至1024条
    while len(data) < 1024:
        data.append("0000000000000000000000000000000000000000000000000000000000000000")

    with open(filename, "w") as txt_file:
        txt_file.write("\n".join(data))

def handle_submit():
    user_instructions = input_text.get("1.0", "end-1c").splitlines()
    binary_instructions = [convert_instruction_to_binary(instr) for instr in user_instructions]

    # 去掉指令中的注释部分
    filtered_instructions = [instr for instr in binary_instructions if instr != '//']
    print(filtered_instructions)

    # 保存到 .txt 文件
    save_to_txt(filtered_instructions, "GPP-PIM operation code.txt")

    result_label.config(text="Saved to GPP-PIM operation code.txt")
    print("Binary code：")
    for instr in filtered_instructions:
        print(instr)

# 创建主窗口
root = tk.Tk()
root.title("GPP-PIM Assembler")

# 创建输入框和按钮
input_text = tk.Text(root, height=40, width=60)
input_text.pack(pady=10)
submit_button = tk.Button(root, text="assemble", command=handle_submit)
submit_button.pack()

# 显示结果的标签
result_label = tk.Label(root, text="")
result_label.pack()

root.mainloop()
