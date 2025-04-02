import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import static java.lang.System.out;

public class main {
    public static void main(String[] args) {
        int MAX_VALUE = 32767;

        int[] ints = new int[10000];
        int size = 0;

        try {
            char[] content = Files.readString(Paths.get(args[0])).toCharArray();

            boolean isNegative = false;
            int startPoint = -1;

            for (int i = 0; i < content.length; i++) {
                if (content[i] == ' ' || content[i] == '\n' || content[i] == '\r') {
                    if (startPoint != -1) {
                        int number = 0;
                        int x = 1;


                        for (int j = i - 1; j >= startPoint; j--) {
                            if(number + (content[j] - '0') * x > MAX_VALUE && isNegative) {
                                number = MAX_VALUE + 1;
                                break;
                            }
                            else if (number + (content[j] - '0') * x > MAX_VALUE){
                                number = MAX_VALUE;
                                break;
                            }

                            number += (content[j] - '0') * x;
                            x *= 10;
                        }

                        if (isNegative)
                            number = -number;

                        ints[size] = number;
                        size++;
                    }
                    startPoint = -1;
                    isNegative = false;
                } else if (content[i] == '-') {
                    isNegative = true;
                } else if (startPoint == -1)
                    startPoint = i;
            }

            // Додаємо останнє число, якщо воно є
            if (startPoint != -1) {
                int number = 0;
                int x = 1;

                for (int j = content.length - 1; j >= startPoint; j--) {
                    if(number + (content[j] - '0') * x > MAX_VALUE) {
                        number = isNegative ? MAX_VALUE + 1 : MAX_VALUE;
                        break;
                    }

                    number += (content[j] - '0') * x;
                    x *= 10;
                }

                if (isNegative) number = -number;
                ints[size++] = number;
            }
        } catch (IOException e) {
            out.println(e.getMessage());
        }


        for(int i = 0; i < size - 1; i++) {
            for (int j = i + 1; j < size; j++) {
                if(ints[i] > ints[j]) {
                    int temp = ints[i];
                    ints[i] = ints[j];
                    ints[j] = temp;
                }
            }
        }

        for(int i = 0; i < size; i++){
            out.print(ints[i] + " ");
        }

        if(size % 2 != 0)
            out.println(ints[size / 2]);
        else
            out.println((ints[size / 2] + ints[size / 2 - 1])/2);

        long sum = 0;
        for(int i = 0; i < size; i++) {
            sum += ints[i];
        }
        out.println((int) sum/size);
    }
}
