
#Область ПрограммныйИнтерфейс

// Выполняет рекурсивный поиск поля в заданной коллекции настроек компоновки данных
//
// Параметры:
//   Поле - ПолеКомпоновкиДанных - Поле компоновки для которого нужно найти элемент настроек
//   ЭлементыСКД - КоллекцияВыбранныхПолейКомпоновкиДанных, КоллекцияЭлементовОтбораКомпоновкиДанных, 
//				   КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных - Коллекция элементов настроек компоновки данных
//
// Возвращаемое значение: 
//   * ВыбранноеПолеКомпоновкиДанных,ЭлементОтбораКомпоновкиДанных - Элемент коллекции настроек, соответствующий полю
//   * Неопределено                                                - Элемент не найден
//
Функция НайтиПолеРекурсивно(Поле, ЭлементыСКД) Экспорт
	
	Для каждого ЭлементСКД Из ЭлементыСКД Цикл
		Если ТипЗнч(ЭлементСКД)=Тип("ГруппаВыбранныхПолейКомпоновкиДанных")
			ИЛИ ТипЗнч(ЭлементСКД)=Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Результат = НайтиПолеРекурсивно(Поле, ЭлементСКД.Элементы);
			Если НЕ Результат=Неопределено Тогда
				Возврат Результат;
			КонецЕсли;  
		ИначеЕсли ТипЗнч(ЭлементСКД)=Тип("ВыбранноеПолеКомпоновкиДанных") И ЭлементСКД.Поле=Поле Тогда
			Возврат ЭлементСКД;
		ИначеЕсли ТипЗнч(ЭлементСКД)=Тип("ЭлементОтбораКомпоновкиДанных") И ЭлементСКД.ЛевоеЗначение=Поле Тогда
			Возврат ЭлементСКД;
		ИначеЕсли ТипЗнч(ЭлементСКД)=Тип("ГруппировкаКомпоновкиДанных") 
			ИЛИ ТипЗнч(ЭлементСКД)=Тип("ГруппировкаТаблицыКомпоновкиДанных") 
			ИЛИ ТипЗнч(ЭлементСКД)=Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
			Для каждого ПолеГруппировки Из ЭлементСКД.ПоляГруппировки.Элементы Цикл
				Если ПолеГруппировки.Поле=Поле Тогда
					Возврат ЭлементСКД;
				КонецЕсли; 
			КонецЦикла; 
			Результат = НайтиПолеРекурсивно(Поле, ЭлементСКД.Структура);
			Если НЕ Результат=Неопределено Тогда
				Возврат Результат;
			КонецЕсли;  
		ИначеЕсли ТипЗнч(ЭлементСКД)=Тип("ТаблицаКомпоновкиДанных") Тогда
			Результат = НайтиПолеРекурсивно(Поле, ЭлементСКД.Строки);
			Если НЕ Результат=Неопределено Тогда
				Возврат Результат;
			КонецЕсли;  
			Результат = НайтиПолеРекурсивно(Поле, ЭлементСКД.Колонки);
			Если НЕ Результат=Неопределено Тогда
				Возврат Результат;
			КонецЕсли;  
		ИначеЕсли ТипЗнч(ЭлементСКД)=Тип("ДиаграммаКомпоновкиДанных") Тогда
			Результат = НайтиПолеРекурсивно(Поле, ЭлементСКД.Серии);
			Если НЕ Результат=Неопределено Тогда
				Возврат Результат;
			КонецЕсли;  
			Результат = НайтиПолеРекурсивно(Поле, ЭлементСКД.Точки);
			Если НЕ Результат=Неопределено Тогда
				Возврат Результат;
			КонецЕсли;  
		КонецЕсли; 
	КонецЦикла;
	Возврат Неопределено;
	
КонецФункции

// Добавляет элемент условного оформления в настройки компоновки данных
//
// Параметры:
//   Настройки  - НастройкиКомпоновкиДанных - Настройки компоновки данных отчета
//   Поле - Строка - Имя поля, для которого добавляется условное оформление
//   Оформление - Структура - Структура элементов оформления
//
Процедура ДобавитьУсловноеОформление(Настройки, Поле, Оформление) Экспорт
	
	НайденныйЭлемент = Неопределено;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных(Поле);
	Для каждого ЭлементУО Из Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементУО.Поля.Элементы.Количество()=1 И ЭлементУО.Поля.Элементы[0].Поле=ПолеКомпоновки И ЭлементУО.Отбор.Элементы.Количество()=0 Тогда
			НайденныйЭлемент = ЭлементУО;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	Если НайденныйЭлемент=Неопределено Тогда
		ЭлементУО = Настройки.УсловноеОформление.Элементы.Добавить();
		ПолеУО = ЭлементУО.Поля.Элементы.Добавить();
		ПолеУО.Поле = ПолеКомпоновки;
		ПолеУО.Использование = Истина;
	Иначе
		ЭлементУО = НайденныйЭлемент;
	КонецЕсли; 
	
	Для каждого Элемент Из Оформление Цикл
		ЭлементОформления = ЭлементУО.Оформление.Элементы.Найти(Элемент.Ключ);
		Если ЭлементОформления=Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		ЭлементОформления.Использование = Истина;
		ЭлементОформления.Значение = Элемент.Значение;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции
// Возвращает представление периода, используя его вид и указанное значение.
Функция ПредставлениеСтандартногоПериода(СтандартныйПериод, ВидПериода) Экспорт
	
	Если СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Месяц Тогда
		Возврат НСтр("ru = 'С такой же даты прошлого месяца'");
	ИначеЕсли СтандартныйПериод.Вариант <> ВариантСтандартногоПериода.ПроизвольныйПериод Тогда
		Возврат Строка(СтандартныйПериод.Вариант);
	КонецЕсли;
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.ПроизвольныйПериод") Тогда
		Возврат Формат(СтандартныйПериод.ДатаНачала, "ДФ='dd MMMM yyyy'") + " - " + Формат(СтандартныйПериод.ДатаОкончания, "ДФ='dd MMMM yyyy'");
	КонецЕсли;
	
	СписокПериодов = СписокФиксированныхПериодов(СтандартныйПериод.ДатаНачала, ВидПериода);
	ЭлементСписка = СписокПериодов.НайтиПоЗначению(СтандартныйПериод.ДатаНачала);
	Если ЭлементСписка <> Неопределено Тогда
		Возврат ЭлементСписка.Представление;
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Возвращает список периодов в диапазоне начала периода.
Функция СписокВычисляемыхПериодов(ВидПериода) Экспорт
	СписокПериодов = Новый СписокЗначений;
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.День") Тогда
		СписокПериодов.Добавить(ВариантСтандартногоПериода.Вчера);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.Сегодня);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.Завтра);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Неделя") Тогда
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлаяНеделя);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлаяНеделяДоТакогоЖеДняНедели);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.Последние7Дней);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ЭтаНеделя);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СНачалаЭтойНедели);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ДоКонцаЭтойНедели);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующаяНеделя);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующаяНеделяДоТакогоЖеДняНедели);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.Следующие7Дней);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Декада") Тогда
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлаяДекада);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлаяДекадаДоТакогоЖеНомераДня);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ЭтаДекада);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СНачалаЭтойДекады);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ДоКонцаЭтойДекады);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующаяДекада);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующаяДекадаДоТакогоЖеНомераДня);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Месяц") Тогда
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлыйМесяц);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлыйМесяцДоТакойЖеДаты);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.Месяц, НСтр("ru = 'С такой же даты прошлого месяца'"));
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ЭтотМесяц);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СНачалаЭтогоМесяца);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ДоКонцаЭтогоМесяца);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующийМесяц);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующийМесяцДоТакойЖеДаты);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Квартал") Тогда
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлыйКвартал);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлыйКварталДоТакойЖеДаты);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ЭтотКвартал);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СНачалаЭтогоКвартала);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ДоКонцаЭтогоКвартала);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующийКвартал);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующийКварталДоТакойЖеДаты);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Полугодие") Тогда
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлоеПолугодие);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ЭтоПолугодие);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующееПолугодие);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СНачалаЭтогоПолугодия);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ДоКонцаЭтогоПолугодия);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлоеПолугодиеДоТакойЖеДаты);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующееПолугодиеДоТакойЖеДаты);
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Год") Тогда
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлыйГод);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ПрошлыйГодДоТакойЖеДаты);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ЭтотГод);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СНачалаЭтогоГода);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.ДоКонцаЭтогоГода);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующийГод);
		СписокПериодов.Добавить(ВариантСтандартногоПериода.СледующийГодДоТакойЖеДаты);
	КонецЕсли;
	
	Возврат СписокПериодов;
КонецФункции

// Возвращает список периодов в диапазоне начала периода.
Функция СписокФиксированныхПериодов(Знач НачалоПериода, ВидПериода) Экспорт
	СписокПериодов = Новый СписокЗначений;
	
	Если НачалоПериода = '00010101' Тогда
		Возврат СписокПериодов;
	КонецЕсли;
	
	НачалоПериода = НачалоДня(НачалоПериода);
	ВыборОтносительногоПериода = (НачалоПериода = "ВыборОтносительногоПериода");
	ПоказыватьВсеОтносительныеПериоды = Ложь;
	
	#Если Клиент Тогда
		МодульОбщегоНазначенияКлиент = сфпОбщегоНазначенияКлиент.сфпОбщийМодуль("ОбщегоНазначенияКлиент");
		Сегодня = МодульОбщегоНазначенияКлиент.ДатаСеанса();
	#Иначе
		Сегодня = ТекущаяДатаСеанса();
	#КонецЕсли
	Сегодня = НачалоДня(Сегодня);
	
	НавигационныйПунктРанееПредставление = НСтр("ru = 'Ранее...'");
	НавигационныйПунктПозжеПредставление = НСтр("ru = 'Позже...'");
	
	Если ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.День") Тогда
		ТекущийДеньНедели   = ДеньНедели(Сегодня);
		ВыбранныйДеньНедели = ДеньНедели(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле. В 1 дне 86400 секунд.
		НачальныйДеньНедели = ТекущийДеньНедели - 5;
		КонечныйДеньНедели  = ТекущийДеньНедели + 1;
		Если ВыбранныйДеньНедели > КонечныйДеньНедели Тогда
			ВыбранныйДеньНедели = ВыбранныйДеньНедели - 7;
		КонецЕсли;
		
		Период = НачалоПериода - 86400 * (ВыбранныйДеньНедели - НачальныйДеньНедели);
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(Период - 86400 * 7, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Счетчик = 1 По 7 Цикл
			СписокПериодов.Добавить(Период, Формат(Период, "ДФ='dd MMMM yyyy, dddd'") + ?(Период = Сегодня, " - " + НСтр("ru = 'сегодня'"), ""));
			Период = Период + 86400;
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(Период + 86400 * 6, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Неделя") Тогда
		ТекущееНачалоНедели   = НачалоНедели(Сегодня);
		ВыбранноеНачалоНедели = НачалоНедели(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле. В 7 днях 604800 секунд.
		РазностьНедель = (ВыбранноеНачалоНедели - ТекущееНачалоНедели) / 604800;
		Коэффициент = (РазностьНедель - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальнаяНеделя = ТекущееНачалоНедели + (2 + Коэффициент*7) * 604800;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(НачальнаяНеделя - 7 * 604800, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Счетчик = 0 По 6 Цикл
			Период = НачальнаяНеделя + Счетчик * 604800;
			КонецПериода  = КонецНедели(Период);
			ПредставлениеПериода = Формат(Период, "ДФ=dd.MM") + " - " + Формат(КонецПериода, "ДЛФ=D") + " (" + НеделяГода(КонецПериода) + " " + НСтр("ru = 'неделя года'") + ")";
			Если Период = ТекущееНачалоНедели Тогда
				ПредставлениеПериода = ПредставлениеПериода + " - " + НСтр("ru = 'эта неделя'");
			КонецЕсли;
			СписокПериодов.Добавить(Период, ПредставлениеПериода);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(НачальнаяНеделя + 13 * 604800, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Декада") Тогда
		ТекущийГод   = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийМесяц   = Месяц(Сегодня);
		ВыбранныйМесяц = Месяц(НачалоПериода);
		ТекущийДень   = День(Сегодня);
		ВыбранныйДень = День(НачалоПериода);
		ТекущаяДекада   = ?(ТекущийДень   <= 10, 1, ?(ТекущийДень   <= 20, 2, 3));
		ВыбраннаяДекада = ?(ВыбранныйДень <= 10, 1, ?(ВыбранныйДень <= 20, 2, 3));
		ТекущаяДекадаАбсолютно   = ТекущийГод*36 + (ТекущийМесяц-1)*3 + (ТекущаяДекада-1);
		ВыбраннаяДекадаАбсолютно = ВыбранныйГод*36 + (ВыбранныйМесяц-1)*3 + (ВыбраннаяДекада-1);
		СтрокаДекада = НСтр("ru = 'декада'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбраннаяДекадаАбсолютно - ТекущаяДекадаАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальнаяДекада = ТекущаяДекадаАбсолютно + 2 + Коэффициент*7;
		КонечнаяДекада  = НачальнаяДекада + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Декада = НачальнаяДекада - 7;
		Год = Цел(Декада/36);
		ДекадаВГоду = Декада - Год*36;
		МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
		ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Декада = НачальнаяДекада По КонечнаяДекада Цикл
			Год = Цел(Декада/36);
			ДекадаВГоду = Декада - Год*36;
			МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
			ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
			Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
			Представление = Формат(Период, "ДФ='MMMM yyyy'") + ", " + Лев("III", ДекадаВМесяце) + " " + СтрокаДекада + ?(Декада = ТекущаяДекадаАбсолютно, " - " + НСтр("ru = 'эта декада'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Декада = КонечнаяДекада + 1;
		Год = Цел(Декада/36);
		ДекадаВГоду = Декада - Год*36;
		МесяцВГоду = Цел(ДекадаВГоду/3) + 1;
		ДекадаВМесяце = ДекадаВГоду - (МесяцВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, (ДекадаВМесяце - 1) * 10 + 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Месяц") Тогда
		ТекущийГод   = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийМесяц   = ТекущийГод*12   + Месяц(Сегодня);
		ВыбранныйМесяц = ВыбранныйГод*12 + Месяц(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйМесяц - ТекущийМесяц - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйМесяц = ТекущийМесяц + 2 + Коэффициент*7;
		КонечныйМесяц  = НачальныйМесяц + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Месяц = НачальныйМесяц - 7;
		Год = Цел((Месяц - 1) / 12);
		МесяцВГоду = Месяц - Год * 12;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Месяц = НачальныйМесяц По КонечныйМесяц Цикл
			Год = Цел((Месяц - 1) / 12);
			МесяцВГоду = Месяц - Год * 12;
			Период = Дата(Год, МесяцВГоду, 1);
			СписокПериодов.Добавить(Период, Формат(Период, "ДФ='MMMM yyyy'") + ?(Год = ТекущийГод И ТекущийМесяц = Месяц, " - " + НСтр("ru = 'этот месяц'"), ""));
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Месяц = КонечныйМесяц + 1;
		Год = Цел((Месяц - 1) / 12);
		МесяцВГоду = Месяц - Год * 12;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Квартал") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущийКвартал   = 1 + Цел((Месяц(Сегодня)-1)/3);
		ВыбранныйКвартал = 1 + Цел((Месяц(НачалоПериода)-1)/3);
		ТекущийКварталАбсолютно   = ТекущийГод*4   + ТекущийКвартал   - 1;
		ВыбранныйКварталАбсолютно = ВыбранныйГод*4 + ВыбранныйКвартал - 1;
		СтрокаКвартал = НСтр("ru = 'квартал'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйКварталАбсолютно - ТекущийКварталАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйКвартал = ТекущийКварталАбсолютно + 2 + Коэффициент*7;
		КонечныйКвартал  = НачальныйКвартал + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Квартал = НачальныйКвартал - 7;
		Год = Цел(Квартал/4);
		КварталВГоду = Квартал - Год*4 + 1;
		МесяцВГоду = (КварталВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Квартал = НачальныйКвартал По КонечныйКвартал Цикл
			Год = Цел(Квартал/4);
			КварталВГоду = Квартал - Год*4 + 1;
			МесяцВГоду = (КварталВГоду-1)*3 + 1;
			Период = Дата(Год, МесяцВГоду, 1);
			Представление = ?(КварталВГоду = 4, "IV", Лев("III", КварталВГоду)) + " " + СтрокаКвартал + " " + Формат(Период, "ДФ='yyyy'") + ?(Квартал = ТекущийКварталАбсолютно, " - " + НСтр("ru = 'этот квартал'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Квартал = КонечныйКвартал + 1;
		Год = Цел(Квартал/4);
		КварталВГоду = Квартал - Год*4 + 1;
		МесяцВГоду = (КварталВГоду-1)*3 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Полугодие") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		ТекущееПолугодие   = 1 + Цел((Месяц(Сегодня)-1)/6);
		ВыбранноеПолугодие = 1 + Цел((Месяц(НачалоПериода)-1)/6);
		ТекущееПолугодиеАбсолютно   = ТекущийГод*2   + ТекущееПолугодие   - 1;
		ВыбранноеПолугодиеАбсолютно = ВыбранныйГод*2 + ВыбранноеПолугодие - 1;
		СтрокаПолугодие = НСтр("ru = 'полугодие'");
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранноеПолугодиеАбсолютно - ТекущееПолугодиеАбсолютно - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальноеПолугодие = ТекущееПолугодиеАбсолютно + 2 + Коэффициент*7;
		КонечноеПолугодие  = НачальноеПолугодие + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		Полугодие = НачальноеПолугодие - 7;
		Год = Цел(Полугодие/2);
		ПолугодиеВГоду = Полугодие - Год*2 + 1;
		МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Полугодие = НачальноеПолугодие По КонечноеПолугодие Цикл
			Год = Цел(Полугодие/2);
			ПолугодиеВГоду = Полугодие - Год*2 + 1;
			МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
			Период = Дата(Год, МесяцВГоду, 1);
			Представление = Лев("II", ПолугодиеВГоду) + " " + СтрокаПолугодие + " " + Формат(Период, "ДФ='yyyy'") + ?(Полугодие = ТекущееПолугодиеАбсолютно, " - " + НСтр("ru = 'это полугодие'"), "");
			СписокПериодов.Добавить(Период, Представление);
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		Полугодие = КонечноеПолугодие + 1;
		Год = Цел(Полугодие/2);
		ПолугодиеВГоду = Полугодие - Год*2 + 1;
		МесяцВГоду = (ПолугодиеВГоду-1)*6 + 1;
		Период = Дата(Год, МесяцВГоду, 1);
		СписокПериодов.Добавить(Период, НавигационныйПунктПозжеПредставление);
		
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Год") Тогда
		ТекущийГод = Год(Сегодня);
		ВыбранныйГод = Год(НачалоПериода);
		
		// Вычисление начального и конечного периода по формуле.
		Коэффициент = (ВыбранныйГод - ТекущийГод - 2)/7;
		Коэффициент = Цел(Коэффициент - ?(Коэффициент < 0, 0.9, 0)); // Отрицательные числа округляются в большую часть.
		НачальныйГод = ТекущийГод + 2 + Коэффициент*7;
		КонечныйГод = НачальныйГод + 6;
		
		// Добавление навигационного пункта "<Ранее>..." для перехода к более ранним периодам.
		СписокПериодов.Добавить(Дата(НачальныйГод-7, 1, 1), НавигационныйПунктРанееПредставление);
		
		// Добавление значений.
		Для Год = НачальныйГод По КонечныйГод Цикл
			СписокПериодов.Добавить(Дата(Год, 1, 1), Формат(Год, "ЧГ=") + ?(Год = ТекущийГод, " - " + НСтр("ru = 'этот год'"), ""));
		КонецЦикла;
		
		// Добавление навигационного пункта "<Позже>..." для перехода к более поздним периодам.
		СписокПериодов.Добавить(Дата(КонечныйГод+7, 1, 1), НавигационныйПунктПозжеПредставление);
		
	КонецЕсли;
	
	Возврат СписокПериодов;
КонецФункции

// Приводит значение перечисления ДоступныеПериодыОтчета к варианту стандартного периода.
Функция ПривестиВидПериодаКСтандартному(ВидПериода) Экспорт
	Если ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.День") Тогда
		Возврат ВариантСтандартногоПериода.Сегодня;
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Неделя") Тогда
		Возврат ВариантСтандартногоПериода.ЭтаНеделя;
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Декада") Тогда
		Возврат ВариантСтандартногоПериода.ЭтаДекада;
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Месяц") Тогда
		Возврат ВариантСтандартногоПериода.ЭтотМесяц;
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Квартал") Тогда
		Возврат ВариантСтандартногоПериода.ЭтотКвартал;
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Полугодие") Тогда
		Возврат ВариантСтандартногоПериода.ЭтоПолугодие;
	ИначеЕсли ВидПериода = ПредопределенноеЗначение("Перечисление." + "ДоступныеПериодыОтчета.Год") Тогда
		Возврат ВариантСтандартногоПериода.ЭтотГод;
	КонецЕсли;
КонецФункции

Функция ПредставлениеОтбора(УзелКД, НаборСтрокКД = Неопределено) Экспорт
	
	Если НаборСтрокКД = Неопределено Тогда
		НаборСтрокКД = УзелКД.Элементы;
	КонецЕсли;
	
	Представление = "";
	
	Для Каждого ЭлементКД Из НаборСтрокКД Цикл
		
		Если Не ЭлементКД.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ЭлементКД) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			Если ЭлементКД.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ Тогда
				ПредставлениеГруппы = НСтр("ru='И'");
			ИначеЕсли ЭлементКД.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли Тогда
				ПредставлениеГруппы = НСтр("ru='ИЛИ'");
			ИначеЕсли ЭлементКД.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
				ПредставлениеГруппы = НСтр("ru='НЕ'");
			КонецЕсли;
			
			ПредставлениеВложенных = ПредставлениеОтбора(УзелКД, ЭлементКД.Элементы);
			Если ПредставлениеВложенных = "" Тогда
				Продолжить;
			КонецЕсли;
			ПредставлениеЭлемента = ПредставлениеГруппы + "(" + ПредставлениеВложенных + ")";
			
		ИначеЕсли ТипЗнч(ЭлементКД) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			ДоступноеПолеОтбораКД = УзелКД.ДоступныеПоляОтбора.НайтиПоле(ЭлементКД.ЛевоеЗначение);
			Если ДоступноеПолеОтбораКД = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДоступноеПолеОтбораКД.Заголовок) Тогда
				ПредставлениеПоля = ДоступноеПолеОтбораКД.Заголовок;
			Иначе
				ПредставлениеПоля = Строка(ЭлементКД.ЛевоеЗначение);
			КонецЕсли;
			
			ПредставлениеЗначения = Строка(ЭлементКД.ПравоеЗначение);
			
			Если ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
				ПредставлениеУсловия = "=";
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
				ПредставлениеУсловия = "<>";
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше Тогда
				ПредставлениеУсловия = ">";
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно Тогда
				ПредставлениеУсловия = ">=";
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше Тогда
				ПредставлениеУсловия = "<";
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
				ПредставлениеУсловия = "<=";
				
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии Тогда
				ПредставлениеУсловия = НСтр("ru = 'В группе'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
				ПредставлениеУсловия = НСтр("ru = 'Не в группе'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
				ПредставлениеУсловия = НСтр("ru = 'В списке'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
				ПредставлениеУсловия = НСтр("ru = 'Не в списке'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии Тогда
				ПредставлениеУсловия = НСтр("ru = 'В списке включая подчиненные'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
				ПредставлениеУсловия = НСтр("ru = 'Не в списке включая подчиненные'");
				
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит Тогда
				ПредставлениеУсловия = НСтр("ru = 'Содержит'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит Тогда
				ПредставлениеУсловия = НСтр("ru = 'Не содержит'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Подобно Тогда
				ПредставлениеУсловия = НСтр("ru = 'Соответствует шаблону'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеПодобно Тогда
				ПредставлениеУсловия = НСтр("ru = 'Не соответствует шаблону'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НачинаетсяС Тогда
				ПредставлениеУсловия = НСтр("ru = 'Начинается с'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеНачинаетсяС Тогда
				ПредставлениеУсловия = НСтр("ru = 'Не начинается с'");
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено Тогда
				ПредставлениеУсловия = НСтр("ru = 'Заполнено'");
				ПредставлениеЗначения = "";
			ИначеЕсли ЭлементКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
				ПредставлениеУсловия = НСтр("ru = 'Не заполнено'");
				ПредставлениеЗначения = "";
			КонецЕсли;
			
			ПредставлениеЭлемента = СокрЛП(ПредставлениеПоля + " " + ПредставлениеУсловия + " " + ПредставлениеЗначения);
			
		КонецЕсли;
		
		Представление = Представление + ?(Представление = "", "", ", ") + ПредставлениеЭлемента;
		
	КонецЦикла;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти 

 