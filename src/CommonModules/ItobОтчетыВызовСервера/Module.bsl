////////////////////////////////////////////////////////////////////////////////
// Отчеты (вызов сервера).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОтчетПоТопливу

// Функция определяет Терминал, Датчик и КалибровочныйГрафик для переданного объекта.
//
// Параметры:
//  ТекущийОбъект	 - СправочникСсылка.ItobВодители, СправочникСсылка.ItobТранспортныеСредства	 - Объект мониторинга.
//  Назначение		 - СправочникСсылка.ItobНазначенияДатчиков, Строка							 - Назначение.
//  НачПериода		 - Дата																		 - Начало период.
// 
// Возвращаемое значение:
//  Структура - Параметры датчика топлива:
//  * Терминал - СправочникСсылка.ItobТерминалы - Терминал.
//  * Датчик - СправочникСсылка.ItobДатчики - Датчик.
//  * КалибровочныйГрафик - СправочникСсылка.ItobКалибровочныеГрафики - Калибровочный график.
//
Функция ПолучитьПараметрыДатчикаТоплива(ТекущийОбъект, Назначение, НачПериода) Экспорт
	
	Возврат ItobОтчеты.ПолучитьПараметрыДатчикаТоплива(ТекущийОбъект, Назначение, НачПериода);
	
КонецФункции

#КонецОбласти 

#Область ДвиженияИСтоянки

// Функция - Получить параметры обновления маршрута на карте
//
// Параметры:
//  Адрес		 - УникальныйИдентификатор - адрес во временном хранилище данных расшифровки.
//  Расшифровка	 - Строка - имя элемента расшифровки.
//  ТекстОшибки	 - Строка - тест ошибки.
// 
// Возвращаемое значение:
//  Неопределено, Структура - Параметры обновления маршрута на карте:
//  * НачПериода - Дата - Начало периода.
//  * КонПериода - Дата - Конец периода.
//  * Объект - ОпределяемыйТип.ItobОбъектМониторинга - Объект мониторинга.
//
Функция ПолучитьПараметрыОбновленияМаршрутаНаКарте(Адрес, Расшифровка, ТекстОшибки = "") Экспорт
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(Адрес);
	ТекущееПоле = ДанныеРасшифровки.Элементы[Расшифровка];
	
	Если ТипЗнч(ТекущееПоле) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля")  Тогда
		
		Поля = ТекущееПоле.ПолучитьПоля();
		Если Поля.Количество() <> 1 Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		// Получим объект(тс/водителя) для которого делается расшифровка.
		Объект = ПолучитьОбъектПостроенияМаршрута(ТекущееПоле);
		Если Объект = Неопределено Тогда
			ТекстОшибки = "В отчет не выведен объект";
			Возврат Неопределено;
		КонецЕсли;
		
		НачалоПериода = Неопределено;
		КонецПериода = Неопределено;
		
		ТекЭл = Поля[0];
		
		Если ТекЭл.Поле = "День" Тогда
			НачалоПериода = НачалоДня(ТекЭл.Значение);
			КонецПериода = КонецДня(ТекЭл.Значение);
			
		ИначеЕсли ТекЭл.Поле = "ВремяНач" Тогда
			НачалоПериода = ТекЭл.Значение;
			КонецПериода = НайтиПолеПериодаВРасшифровке(Расшифровка, "ВремяКон", ДанныеРасшифровки, "Вперед");
			
		ИначеЕсли ТекЭл.Поле = "ВремяКон" Тогда
			НачалоПериода = НайтиПолеПериодаВРасшифровке(Расшифровка, "ВремяНач", ДанныеРасшифровки, "Назад");
			КонецПериода = ТекЭл.Значение;
			
		ИначеЕсли ТекЭл.Поле = "Объект" Тогда
			ПараметрыОтбора = ДанныеРасшифровки.Настройки.ПараметрыДанных.Элементы;
			Для Каждого Эл Из ПараметрыОтбора Цикл
				ИмяПараметра = Строка(Эл.Параметр);
				Если ИмяПараметра = "ДатаНачала" Или ИмяПараметра = "НачПериода" Тогда
					НачалоПериода = Эл.Значение;
				ИначеЕсли ИмяПараметра = "ДатаОкончания" Или ИмяПараметра = "КонПериода" Тогда
					КонецПериода = Эл.Значение;
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли ТекЭл.Поле = "МестоСтоянки" Тогда
			НачалоПериода = НайтиПолеПериодаВРасшифровке(Расшифровка, "ВремяНач", ДанныеРасшифровки, "Назад");
			КонецПериода = НайтиПолеПериодаВРасшифровке(Расшифровка, "ВремяКон", ДанныеРасшифровки, "Назад");
			
		ИначеЕсли ТекЭл.Поле = "СостояниеСтрока" Тогда
			НачалоПериода = НайтиПолеПериодаВРасшифровке(Расшифровка, "ВремяНач", ДанныеРасшифровки, "Вперед");
			КонецПериода = НайтиПолеПериодаВРасшифровке(Расшифровка, "ВремяКон", ДанныеРасшифровки, "Вперед");
			
		Иначе
			Возврат Неопределено;
			
		КонецЕсли;
	
		Если НачалоПериода = Неопределено Тогда
			ТекстОшибки = "В отчет не выведено время начала маршрута";
			Возврат Неопределено;
		КонецЕсли;
		
		Если КонецПериода = Неопределено Тогда
			ТекстОшибки = "В отчет не выведено время окончания маршрута";
			Возврат Неопределено;
		КонецЕсли;
			
		Возврат НовыйПараметрыОбновленияМаршрутаНаКарте(Объект, НачалоПериода, КонецПериода);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ДвиженияИСтоянки

// Функция - Получить параметры отчета на сервере
//
// Параметры:
//	Расшифровка					 - Произвольный - Значение расшифровки точки, серии или значения диаграммы.
//  ДополнительныйТекстКОтчету	 - Строка - дополнительный текст к отчету 
//  ДанныеРасшифровкиАдрес		 - Строка - адрес, указывающий на значение во временном хранилище. 
//  Результат					 - ТабличныйДокумент - результат формирования отчета. 
//  КомпоновщикНастроек			 - КомпоновщикНастроекКомпоновкиДанных - компоновщик настроек. 
// 
// Возвращаемое значение:
//	Структура
//
Функция ПолучитьПараметрыОтчетаНаСервере(Расшифровка, ДополнительныйТекстКОтчету, ДанныеРасшифровкиАдрес, Результат, КомпоновщикНастроек) Экспорт
	
	СправочникТранспортныеСредства 	= "СправочникСсылка."+ItobВызовСервераПовтИсп.ПолучитьИмяОбъекта("ТранспортныеСредства");
	СправочникВодители 				= "СправочникСсылка."+ItobВызовСервераПовтИсп.ПолучитьИмяОбъекта("Водители");
	
	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(ДанныеРасшифровкиАдрес);
	ЭлементРасшифровки = ДанныеРасшифровки.Элементы.Получить(Расшифровка);
	ПолеРасшифровки = ЭлементРасшифровки.ПолучитьПоля()[0];	// Выбранное поле.
	ВозможныйОбъектМониторинга = ПолеРасшифровки.Значение;
	Если ВозможныйОбъектМониторинга = Null Тогда
		Возврат Неопределено;
	Иначе
		Если ТипЗнч(ВозможныйОбъектМониторинга) = Тип(СправочникТранспортныеСредства)
			Или ТипЗнч(ВозможныйОбъектМониторинга) = Тип(СправочникВодители)Тогда
			ОбъектМониторинга = ЭлементРасшифровки.ПолучитьПоля()[0].Значение;
			Если ОбъектМониторинга.ЭтоГруппа Тогда
				ОбъектМониторинга = Неопределено;
			    Возврат Неопределено;
			КонецЕсли; 
		Иначе
			РодительРасшифровки = ЭлементРасшифровки.ПолучитьРодителей()[0];
			ОбъектРасшифровки = ДанныеРасшифровки.Элементы.Получить(РодительРасшифровки.Идентификатор).ПолучитьРодителей()[0];
			Если Не ТипЗнч(ВозможныйОбъектМониторинга) = Тип("Дата") Тогда
				ПроверкаПериода = ДанныеРасшифровки.Элементы.Получить(РодительРасшифровки.Идентификатор+1).ПолучитьПоля()[0];
				Если ПроверкаПериода.Поле = "Период" Тогда
					Для Счетчик = 1 По Результат.ШиринаТаблицы Цикл
						ПроверкаПериода = ДанныеРасшифровки.Элементы.Получить(Расшифровка-Счетчик).ПолучитьПоля()[0];
						Если ПроверкаПериода.Поле = "Период" Тогда
							Прервать;
						КонецЕсли; 
					КонецЦикла; 
				    ВозможныйОбъектМониторинга = ПроверкаПериода.Значение;
				КонецЕсли;
			КонецЕсли; 
			Если ТипЗнч(ОбъектРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
				ОбъектМониторинга = ОбъектРасшифровки.ПолучитьПоля()[0].Значение;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	
	ПараметрыОтчета = Новый Структура("Объект,НачалоПериода,КонецПериода", ОбъектМониторинга);
	
	Если ТипЗнч(ПолеРасшифровки.Значение) = Тип("Дата") Тогда
	    ПараметрыОтчета.НачалоПериода = НачалоДня(ПолеРасшифровки.Значение);
	    ПараметрыОтчета.КонецПериода = КонецДня(ПолеРасшифровки.Значение);
		Возврат ПараметрыОтчета;
	ИначеЕсли НЕ ТипЗнч(ПолеРасшифровки.Значение) = Тип(СправочникТранспортныеСредства) Тогда
		Возврат Неопределено;
	КонецЕсли;
	// Обрабатываем период.
	// Если выбрано любое другое поле, то период берем из заданных настроек.
	ВыходИзПользовательскихНастроек = 0;
	Для Каждого ЭлементПользовательскихНастроек Из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		ПараметрЭлементаПользовательскихНастроекСтрока = Строка(ЭлементПользовательскихНастроек.Параметр);
		Если ПараметрЭлементаПользовательскихНастроекСтрока = "НачалоПериода" Тогда
			Если ЭлементПользовательскихНастроек.Использование Тогда
				Если ТипЗнч(ЭлементПользовательскихНастроек.Значение) = Тип("Дата") Тогда
				    ПараметрыОтчета.НачалоПериода = НачалоДня(ЭлементПользовательскихНастроек.Значение);
				Иначе	
					ПараметрыОтчета.НачалоПериода = НачалоДня(ЭлементПользовательскихНастроек.Значение.Дата);
				КонецЕсли; 
			Иначе
				ПараметрыОтчета.Очистить();
				Прервать;
			КонецЕсли; 
			Если ВыходИзПользовательскихНастроек = 2 Тогда
				Прервать;
			Иначе
				ВыходИзПользовательскихНастроек = ВыходИзПользовательскихНастроек+1;
	    	КонецЕсли; 
		ИначеЕсли ПараметрЭлементаПользовательскихНастроекСтрока = "КонецПериода" Тогда
			Если ЭлементПользовательскихНастроек.Использование Тогда
				Если ТипЗнч(ЭлементПользовательскихНастроек.Значение) = Тип("Дата") Тогда
					ПараметрыОтчета.КонецПериода = КонецДня(ЭлементПользовательскихНастроек.Значение);
				Иначе	
					ПараметрыОтчета.КонецПериода = КонецДня(ЭлементПользовательскихНастроек.Значение.Дата);
				КонецЕсли; 
			Иначе
				ПараметрыОтчета.Очистить();
				Прервать;
			КонецЕсли; 
			Если ВыходИзПользовательскихНастроек = 2 Тогда
				Прервать;
			Иначе
				ВыходИзПользовательскихНастроек = ВыходИзПользовательскихНастроек+1;
	    	КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат ПараметрыОтчета;
КонецФункции // ПолучитьИзВременногоХранилищаНаСервере()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ДвиженияИСтоянки

Функция НовыйПараметрыОбновленияМаршрутаНаКарте(Объект, НачПериода, КонПериода)
	Параметры = Новый Структура();
	
	Параметры.Вставить("Объект", Объект);
	Параметры.Вставить("НачПериода", НачПериода);
	Параметры.Вставить("КонПериода", КонПериода);
	
	Возврат Параметры;
КонецФункции

// Возвращает тс/водителя в данных расшифровки отчета движения и стоянки.
//
Функция ПолучитьОбъектПостроенияМаршрута(ТекущееПоле)
	
	Если ТипЗнч(ТекущееПоле) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля")  Тогда
		Для Каждого ТекЭл Из ТекущееПоле.ПолучитьПоля() Цикл 
			
			Если ТекЭл.Поле = "Объект" Тогда
				Возврат ТекЭл.Значение;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого ТекЭл Из ТекущееПоле.ПолучитьРодителей() Цикл 
		Результат = ПолучитьОбъектПостроенияМаршрута(ТекЭл);
		Если ЗначениеЗаполнено(Результат) Тогда
		    Возврат Результат;
		КонецЕсли; 
	КонецЦикла;
	
КонецФункции

Функция НайтиПолеПериодаВРасшифровке(Расшифровка, ИмяПоля, ДанныеРасшифровки, НаправлениеПоиска = "Вперед")
	
	Если НаправлениеПоиска = "Вперед" Тогда
		Количество = Расшифровка + 1;
		СтопИндекс = ДанныеРасшифровки.Элементы.Количество() - 1;
	Иначе
		Количество = Расшифровка - 1;
		СтопИндекс = 0;
	КонецЕсли;
	
	Пока Количество <> СтопИндекс Цикл
		
		СледПоле = ДанныеРасшифровки.Элементы[Количество];
		Если ТипЗнч(СледПоле) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля")  Тогда 
			СледПоля = СледПоле.ПолучитьПоля();
			Если СледПоля.Количество() <> 1 Тогда
				Продолжить;
			КонецЕсли;
			СледЭл = СледПоля[0];
			Если СледЭл.Поле = ИмяПоля Тогда
				Возврат СледЭл.Значение;
			КонецЕсли;
		КонецЕсли;
		Количество = Количество + ?(Количество > СтопИндекс, -1, 1);
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
