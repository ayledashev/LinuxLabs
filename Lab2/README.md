# Л/Р №2 по Администрированию ОС
## Студент: Ледащев А.Ю. БВБО-01-16

Остановился на 7 задании 3 часть

## Задание 1 (Установка ОС и настройка LVM, RAID)
1. Создание новой виртуальной машины, выдав ей следующие характеристики:
* 1 gb ram
* 1 cpu
* 2 hdd (назвав их ssd1, ssd2 и назначил равный размер, поставив галочки hot swap и ssd)
* SATA контроллер настроен на 4 порта
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_1.png)
2. Начало установки Linux:
* Настройка отдельного раздела под /boot: Выбрав первый диск, создал на нем новую таблицу разделов
    + Partition size: 512M
    + Mount point: /boot
    + Повторил настройки для второго диска, выбрав mount point:none
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_2.png)
* Настройка RAID
    + Выбрал свободное место на первом диске и настроил в качестве типа раздела physical volume for RAID
    + Выбрал "Done setting up the partition"
    + Повторил настройку для второго диска
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_3.png)
* Выбрал пункт "Configure software RAID"
    + Create MD device
    + Software RAID device type: Выберал зеркальный массив
    + Active devices for the RAID XXXX array: Выбрал оба диска
    + Spare devices: Оставил 0 по умолчанию
    + Active devices for the RAID XX array: Выбрал разделы, которые создавал под raid
    + Finish
* В итоге получил: 
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_4.png)
* Настройка LVM: Выбрал Configure the Logical Volume Manager
    + Keep current partition layout and configure LVM: Yes
    + Create volume group
    + Volume group name: system
    + Devices for the new volume group: Выбрал созданный RAID
    + Create logical volume
    + logical volume name: root
    + logical volume size: 2\5 от размера диска
    + Create logical volume
    + logical volume name: var
    + logical volume size: 2\5 от размера диска
    + Create logical volume
    + logical volume name: log
    + logical volume size: 1\5 от размера диска
     + Выбрав Display configuration details получил следующую картину: 
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_5.png)
    + Завершив настройку LVM увидел следующее:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_6.png)
* Разметка разделов: по-очереди выбрал каждый созданный в LVM том и разметил их, например, для root так:
    + Use as: ext4
    + mount point: /
    + повторил операцию разметки для var и log выбрав соответствующие точки монтирования (/var и /var/log), получив следующий результат:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_7.png)
* Финальный результат получился вот таким:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_8.png)
3. Закончил установку ОС, поставив grub на первое устройство (sda) и загрузил систему.
4. Выполнил копирование содержимого раздела /boot с диска sda (ssd1) на диск sdb (ssd2)
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_9.png)
5. Выполнил установку grub на второе устройство:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_10.png)
* Результат команды fdisk -l:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_11.png)
* Результат команды lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT:
    + sda - ssd1
    + sdb -ssd2
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_12.png)
* Посмотрел информацию о текущем raid командой cat /proc/mdstat:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_13.png)
Увидел, что активны два raid1 sda2[0] и sdb2[1]

* Выводы команд: pvs, vgs, lvs, mount:

![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_14.png)
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_15.png)
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part1/Screenshot_16.png)
* С помощью этих команд увидел информацию об physical volumes, volume groups, logical volumes, примонтированных устройств.
## Вывод
В этом задании научился устанавливать ОС Linux, настраивать LVM и RAID, а также ознакомился с командами:
 * lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
 * fdisk -l
 * pvs,lvs,vgs
 * cat /proc/mdstat
 * mount
 * dd if=/dev/xxx of=/dev/yyy
 * grub-install /dev/XXX 
* В результате получил виртуальную машину с дисками ssd1, ssd2.

## Задание 2 (Эмуляция отказа одного из дисков)
1. Удаление диска ssd1 в свойствах машины, проверка работоспособности виртуальной машины.
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_1.png)
2. Проверка статуса RAID-массива cat /proc/mdstat
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_2.png)
3. Добавление в интерфейсе VM нового диска такого же размера с названием ssd3
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_3.png)
4. Выполнение операций:
* Просмотр нового диска, что он приехал в систему командой fdisk -l
* Копирование таблиц разделов со старого диска на новый: sfdisk -d /dev/XXXX | sfdisk /dev/YYY
* Результат
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_4.png)
* Добавление в рейд массив нового диска: mdadm --manage /dev/md0 --add /dev/YYY
* Результат cat /proc/mdstat
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_5.png)
5. Выполение синхронизации разделов, не входящих в RAID
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_6.png)
6. Установка grub на новый диск

![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_7.png)

7. Перезагрузка ВМ и проверка, что все работает
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part2/Screenshot_8.png)
## Вывод
В этом задании научился:
* Удалять диск ssd1
* Проверять статус RAID-массива
* Копировать таблицу разделов со старого диска на новый
* Добавлять в рейд массив новый диск
* Выполнять синхронизацию разделов, не входящих в RAID

Изучил новые команды:
* sfdisk -d /dev/XXXX | sfdisk /dev/YYY
* mdadm --manage /dev/md0 --add /dev/YSYY

Результат: Удален диск ssd1, добавлен диск ssd3, ssd2 сохранили

## Задание 3 (Добавление новых дисков и перенос раздела)
1. Эмулирование отказа диска ssd2 и просмотр состояние дисков RAID
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_1.png)
2. Добавление нового ssd диска
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_2.png)
3. Перенос данных с помощью LVM
* Копирование файловую таблицу со старого диска на новый
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_3.png)
* Копирование данных /boot на новый диск
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_4.png)
* Перемонтировака /boot на живой диск
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_5.png)
* Установка grub на новый диск
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_6.png)

Grub устанавливаем, чтобы могли загрузить ОС с этого диска
* Создание нового RAID-массива с включением туда только одного нового ssd диска:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_7.png)
* Проверка результата
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_8.png)

Появился /dev/md63

4. Настройка LVM
* Выполнение команды pvs для просмотра информации о текущих физических томах
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_9.png)
* Создание нового физического тома, включив в него ранее созданный RAID массив:
* Выполнение команд lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT и pvs
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_10.png)

К md63 добавился FSTYPE - LVM2_member, так же dev/md63 добавился к результату команды pvs
* Увеличение размера Volume Group system
* Выполнение команд
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
```
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_11.png)
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_12.png)

LV var,log,root находятся на /dev/md0
* Перемещение данных со старого диска на новый
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_13.png)
* Выполнение команд:
```
vgdisplay system -v
pvs
vgs
lvs -a -o+devices
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
```
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_14.png)
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_15.png)
* Изменение VG, удалив из него диск старого raid.
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_16.png)
```
lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT
pvs
vgs
```
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_17.png)

В выводе команды pvs у /dev/md0 исчезли VG и Attr.
В выводе команды vgs #PV - уменьшилось на 1, VSize, VFree - стали меньше
* Перемонтировка /boot на второй диск, проверка, что boot не пустой
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_18.png)
5. Удаление ssd3 и добавление ssd5,hdd1,hdd2
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_19.png)
Тут названия дисков и md поменялись, т.к я сделал клонирования ВМ
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_20.png)

6. Восстановление работы основного RAID массива:
* Копирование таблицы разделов:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_21.png)
7. Копирование загрузочного раздела /boot с диска ssd4 на ssd5
8. Установка grub на ssd5
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_22.png)
9. Изменение размера второго раздела диска ssd5
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_23.png)
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_24.png)
10. Перечитывание таблицы разделов
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_25.png)
* Добавление нового диска к текущему raid массиву
* Расширение количество дисков в массиве до 2-х штук:
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_26.png)
11. Увеличение размера раздела на диске ssd4
* Запуск утилиты для работы с разметкой дисков
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_27.png)
12. Перечитаем таблицу разделов
13. Расширение размера raid
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_28.png)

Размер md127 стал 7.5G
* Вывод команды pvs
* Расширение размера PV
* Вывод команды pvs
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_29.png)
14. Добавление вновь появившееся место VG var,root
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_30.png)
15. Перемещение /var/log на новые диски
* Посмотрел какие имена имеют новые hhd диски
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_31.png)
* Создание RAID массива
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_32.png)
* Создание нового PV на рейде из больших дисков
* Создание в этом PV группу с названием data
* Создание логического тома с размером всего свободного пространства и присвоением ему имени var_log
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_34.png)
* Отформатирование созданного раздела в ext4
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_35.png)
16. Перенос данных логов со старого раздела на новый
* Примонтирование временно нового хранилище логов
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_36.png)
* Выполнение синхронизации разделов
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_37.png)
* Процессы работающие с /var/log
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_38.png)
* Остановка этих процессов
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_39.png)
* Выполнение финальной синхронизации разделов
* Поменял местами разделы
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_40.png)
17. Правка /etc/fstab
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_41.png)
18. Проверка всего
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_42.png)
![alt-текст](https://github.com/lasfire/LinuxLabs/blob/master/Lab2/part3/Screenshot_43.png)
