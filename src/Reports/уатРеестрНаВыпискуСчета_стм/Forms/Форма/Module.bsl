#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаНач = НачалоМесяца(ТекущаяДата());
	ДатаКон = КонецМесяца(ТекущаяДата());
	
	ОрганизацияПользователя = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Организация.Пустая() Тогда
		Организация = ОрганизацияПользователя;
	КонецЕсли;
	Если Валюта.Пустая() Тогда
		Валюта = ВалютаРеглУчета;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаПериода(Команда)
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогПериода.Период.ДатаНачала = ДатаНач;
	ДиалогПериода.Период.ДатаОкончания = ДатаКон;
	ДиалогПериода.Показать(Новый ОписаниеОповещения("НастройкаПериодаЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериодаЗавершение(Период, ДополнительныеПараметры) Экспорт
    
    Если Не Период = Неопределено Тогда
        ДатаНач = Период.ДатаНачала;
        ДатаКон = Период.ДатаОкончания;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	Если НЕ ЗначениеЗаполнено(ДатаКон) ИЛИ НЕ ЗначениеЗаполнено(ДатаКон) ИЛИ НЕ ЗначениеЗаполнено(Контрагент) Тогда
		ПоказатьПредупреждение(Неопределено, "Не указаны обязательные параметры отчета!");
		Возврат;
	КонецЕсли;
	
	СформироватьОтчетСервер();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчетСервер()
	Перем Ошибки;

	ТабДок.Очистить();         
	Макет = Отчеты.уатРеестрНаВыпискуСчета_стм.ПолучитьМакет("Отчет");
		
	Запрос1 = Новый Запрос;      // запрос по параметрам выработки
	
	Запрос1.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПредоставленныеУслуги.ПараметрВыработки КАК ПараметрВыработки,
	|	уатПредоставленныеУслуги.ПараметрВыработки.Временный КАК ЭтоВремя,
	|	уатПредоставленныеУслуги.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	РегистрНакопления.уатПредоставленныеУслуги.Обороты(
	|			&ДатаНач,
	|			&ДатаКон,
	|			,
	|			ДоговорКонтрагента.Владелец = &Контрагент
	|				И ПолучательУслуг = ЗНАЧЕНИЕ(Перечисление.уатПолучателиУслуг.Контрагент)
	|				И (&Организация = НЕОПРЕДЕЛЕНО
	|					ИЛИ Организация = &Организация)) КАК уатПредоставленныеУслуги
	|ГДЕ
	|	(&ТСВыбыло
	|			ИЛИ уатПредоставленныеУслуги.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1))
	|
	|СГРУППИРОВАТЬ ПО
	|	уатПредоставленныеУслуги.ПараметрВыработки,
	|	уатПредоставленныеУслуги.Номенклатура.ЕдиницаИзмерения,
	|	уатПредоставленныеУслуги.ПараметрВыработки.Временный";
	
	Запрос1.УстановитьПараметр("ДатаНач", ДатаНач);
	Запрос1.УстановитьПараметр("ДатаКон", ДатаКон);
	Запрос1.УстановитьПараметр("Контрагент", Контрагент);
	Запрос1.УстановитьПараметр("ТСВыбыло", ВыбывшиеТС);
	Запрос1.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	
	Результат1 = Запрос1.Выполнить();
	ТЗ=Результат1.Выгрузить();
	ТЗ.Колонки.Добавить("ИтогАвто",Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("ИтогОбъект",Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("ИтогОбщий",Новый ОписаниеТипов("Число"));
	ТЗ.ЗаполнитьЗначения(0,"ИтогОбщий");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПредоставленныеУслуги.ТС КАК ТС,
	|	ПРЕДСТАВЛЕНИЕ(уатПредоставленныеУслуги.ТС) КАК ТСПредставление,
	|	уатПредоставленныеУслуги.ПутевойЛист КАК ПутЛист,
	|	уатПредоставленныеУслуги.ПараметрВыработки КАК ПараметрВыработки,
	|	ПРЕДСТАВЛЕНИЕ(уатПредоставленныеУслуги.ПараметрВыработки) КАК ПараметрВыработкиПредставление,
	|	уатПредоставленныеУслуги.ОбъектСтроительства КАК ОбъектСтроительства,
	|	ПРЕДСТАВЛЕНИЕ(уатПредоставленныеУслуги.ОбъектСтроительства) КАК ОбъектСтроительстваПредставление,
	|	уатПредоставленныеУслуги.КоличествоОборот КАК КоличествоОборот,
	|	ВЫБОР
	|		КОГДА уатПредоставленныеУслуги.Валюта = &ВалютаОтчета
	|			ТОГДА уатПредоставленныеУслуги.СуммаОборот
	|		КОГДА &ВалютаОтчета = &ВалютаРегл
	|			ТОГДА уатПредоставленныеУслуги.СуммаРеглОборот
	|		ИНАЧЕ уатПредоставленныеУслуги.СуммаОборот * ЕСТЬNULL(КурсыВалютУслуг.Курс, 1) / ЕСТЬNULL(&ВалютаОтчетаКурс, 1) * ЕСТЬNULL(&ВалютаОтчетаКратность, 1) / ЕСТЬNULL(КурсыВалютУслуг.Кратность, 1)
	|	КОНЕЦ - ВЫБОР
	|		КОГДА &ВалютаОтчета = &ВалютаРегл
	|			ТОГДА уатПредоставленныеУслуги.СуммаНДСОборот
	|		ИНАЧЕ уатПредоставленныеУслуги.СуммаНДСОборот * ЕСТЬNULL(&ВалютаРеглКурс, 1) / ЕСТЬNULL(&ВалютаОтчетаКурс, 1) * ЕСТЬNULL(&ВалютаОтчетаКратность, 1) / ЕСТЬNULL(&ВалютаРеглКратность, 1)
	|	КОНЕЦ КАК СуммаБезНДС,
	|	ВЫБОР
	|		КОГДА &ВалютаОтчета = &ВалютаРегл
	|			ТОГДА уатПредоставленныеУслуги.СуммаНДСОборот
	|		ИНАЧЕ уатПредоставленныеУслуги.СуммаНДСОборот * ЕСТЬNULL(&ВалютаРеглКурс, 1) / ЕСТЬNULL(&ВалютаОтчетаКурс, 1) * ЕСТЬNULL(&ВалютаОтчетаКратность, 1) / ЕСТЬNULL(&ВалютаРеглКратность, 1)
	|	КОНЕЦ КАК СуммаНДСОборот,
	|	ВЫБОР
	|		КОГДА уатПредоставленныеУслуги.Валюта = &ВалютаОтчета
	|			ТОГДА уатПредоставленныеУслуги.СуммаОборот
	|		КОГДА &ВалютаОтчета = &ВалютаРегл
	|			ТОГДА уатПредоставленныеУслуги.СуммаРеглОборот
	|		ИНАЧЕ уатПредоставленныеУслуги.СуммаОборот * ЕСТЬNULL(КурсыВалютУслуг.Курс, 1) / ЕСТЬNULL(&ВалютаОтчетаКурс, 1) * ЕСТЬNULL(&ВалютаОтчетаКратность, 1) / ЕСТЬNULL(КурсыВалютУслуг.Кратность, 1)
	|	КОНЕЦ КАК СуммаОборот
	|ИЗ
	|	РегистрНакопления.уатПредоставленныеУслуги.Обороты(
	|			&ДатаНач,
	|			&ДатаКон,
	|			,
	|			ДоговорКонтрагента.Владелец = &Контрагент
	|				И ПолучательУслуг = ЗНАЧЕНИЕ(Перечисление.уатПолучателиУслуг.Контрагент)
	|				И (&Организация = НЕОПРЕДЕЛЕНО
	|					ИЛИ Организация = &Организация)) КАК уатПредоставленныеУслуги
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаКон, ) КАК КурсыВалютУслуг
	|		ПО уатПредоставленныеУслуги.Валюта = КурсыВалютУслуг.Валюта
	|ГДЕ
	|	(&ТСВыбыло
	|			ИЛИ уатПредоставленныеУслуги.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1))
	|ИТОГИ
	|	СУММА(КоличествоОборот),
	|	СУММА(СуммаБезНДС),
	|	СУММА(СуммаНДСОборот),
	|	СУММА(СуммаОборот)
	|ПО
	|	ОБЩИЕ,
	|	ОбъектСтроительства,
	|	ТС,
	|	ПараметрВыработки";
	
	Запрос.УстановитьПараметр("ДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("ДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ТСВыбыло", ВыбывшиеТС);
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	
	КурсКратностьВалютыОтчета = уатОбщегоНазначенияТиповые.ПолучитьКурсВалюты(Валюта, ДатаКон);
	КурсКратностьВалютыРегл   = уатОбщегоНазначенияТиповые.ПолучитьКурсВалюты(ВалютаРеглУчета, ДатаКон);
	
	Запрос.УстановитьПараметр("ВалютаОтчета",          Валюта);
	Запрос.УстановитьПараметр("ВалютаОтчетаКурс",      КурсКратностьВалютыОтчета.Курс);
	Запрос.УстановитьПараметр("ВалютаОтчетаКратность", КурсКратностьВалютыОтчета.Кратность);
	Запрос.УстановитьПараметр("ВалютаРегл",            ВалютаРеглУчета);
	Запрос.УстановитьПараметр("ВалютаРеглКурс",        КурсКратностьВалютыРегл.Курс);
	Запрос.УстановитьПараметр("ВалютаРеглКратность",   КурсКратностьВалютыРегл.Кратность);
	
	Результат = Запрос.Выполнить();
	
	ОбластьЗаголовок = ?(ФлагФаксимиле, Макет.ПолучитьОбласть("ЗаголовокФаксимиле"), Макет.ПолучитьОбласть("Заголовок"));
	Если ФлагФаксимиле Тогда
		ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
		ПодписиИФаксимиле.Вставить("Логотип", "ФайлЛоготип");
		уатОбщегоНазначения.ЗаполнитьФаксимилеВОбластиМакета(ОбластьЗаголовок, Организация, ПодписиИФаксимиле, Ошибки);
	Конецесли;

	ОбластьПодвал = ?(ФлагФаксимиле, Макет.ПолучитьОбласть("ПодвалФаксимиле"), Макет.ПолучитьОбласть("Подвал"));

	ОбластьШапка1Таблицы = Макет.ПолучитьОбласть("Шапка1Таблицы");
	ОбластьШапка2Таблицы = Макет.ПолучитьОбласть("Шапка2Таблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог1 = Макет.ПолучитьОбласть("ОбщиеИтоги1");
	ОбластьОбщийИтог2 = Макет.ПолучитьОбласть("ОбщиеИтоги2");
	ОбластьОбъектСтроительстваЗаголовок = Макет.ПолучитьОбласть("ОбъектСтроительства");
	ОбластьОбъектСтроительства1 = Макет.ПолучитьОбласть("ОбъектСтроительства1");
	ОбластьТС1 = Макет.ПолучитьОбласть("ТС1");
	ОбластьТС2 = Макет.ПолучитьОбласть("ТС2");
	ОбластьТС3 = Макет.ПолучитьОбласть("ТС3");
	ОбластьДетальныхЗаписей1 = Макет.ПолучитьОбласть("Детали1");
	ОбластьДетальныхЗаписей2 = Макет.ПолучитьОбласть("Детали2");
	ОбластьДетальныхЗаписей3 = Макет.ПолучитьОбласть("Детали3");
	ОбластьПусто = Макет.ПолучитьОбласть("Пусто");
	
	ОбластьЗаголовок.Параметры.ДатаКон=ДатаКон;
	ОбластьЗаголовок.Параметры.Контрагент=Контрагент.НаименованиеПолное;

	ОбластьЗаголовок.Параметры.Исполнитель= уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Организация), "НаименованиеДляПечатныхФорм");
	ОбластьЗаголовок.Параметры.Период=НРег(ПредставлениеПериода(НачалоДня(ДатаНач), КонецДня(ДатаКон), "ФП = Истина"));
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапка1Таблицы);
	
	ОбластьШапкаПараметрыВыработки=Макет.ПолучитьОбласть("ПараметрыВыработки");
	Выборка1=Результат1.Выбрать();
	
	Пока Выборка1.Следующий() Цикл
		СтрокаПараметр = "" + Выборка1.ПараметрВыработки;
		Если ЗначениеЗаполнено(Выборка1.ПараметрВыработки) Тогда
			Если Выборка1.ЭтоВремя Тогда
				СтрокаПараметр = СтрокаПараметр + ", часов"; 
			Иначе
				СтрокаПараметр = СтрокаПараметр + ", " + Выборка1.ЕдиницаИзмерения; 
			КонецЕсли;
		КонецЕсли;
		ОбластьШапкаПараметрыВыработки.Параметры.ПараметрВыработки = СтрокаПараметр; 
		ТабДок.Присоединить(ОбластьШапкаПараметрыВыработки);  // Шапка
	КонецЦикла;
	
	ТабДок.Присоединить(ОбластьШапка2Таблицы);             // с шапкой закончили
	
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыборкаОбщийИтог.Следующий();		// Общий итог
	
	ВыборкаОбъектСтроительства = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТЗ.ЗаполнитьЗначения(0,"ИтогОбъект");
	
	Если уатОбщегоНазначенияТиповые.уатЕстьИзмерениеРегистра("ОбъектСтроительства", РегистрыНакопления.уатДоходы) Тогда
		
		Пока ВыборкаОбъектСтроительства.Следующий() Цикл       // цикл по объекту строительства
			ОбластьОбъектСтроительстваЗаголовок.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, 1);
			
			ВыборкаТС = ВыборкаОбъектСтроительства.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ТЗ.ЗаполнитьЗначения(0,"ИтогОбъект");
			
			Пока ВыборкаТС.Следующий() Цикл                    // цикл по автомобилям
				ВыборкаПараметрВыработки = ВыборкаТС.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				ТЗ.ЗаполнитьЗначения(0,"ИтогАвто");
				Пока ВыборкаПараметрВыработки.Следующий() Цикл
					ВыборкаДетали = ВыборкаПараметрВыработки.Выбрать();
					
					Пока ВыборкаДетали.Следующий() Цикл       // цикл по путевым листам
						ОбластьДетальныхЗаписей1.Параметры.Номер = ВыборкаДетали.ПутЛист.Номер;
						ОбластьДетальныхЗаписей1.Параметры.Дата = ВыборкаДетали.ПутЛист.Дата;
						ОбластьДетальныхЗаписей1.Параметры.ТС = Строка(ВыборкаДетали.ТС);
						
						//ТабДок.Вывести(ОбластьДетальныхЗаписей1, ВыборкаДетали.Уровень());
						ТабДок.Вывести(ОбластьДетальныхЗаписей1, 3);
						
						Для ин=0 По ТЗ.Количество()-1 Цикл
							Если ТЗ[ин].ПараметрВыработки=ВыборкаДетали.ПараметрВыработки Тогда
								ОбластьДетальныхЗаписей2.Параметры.Заполнить(ВыборкаДетали);
								
								//ТабДок.Присоединить(ОбластьДетальныхЗаписей2, ВыборкаДетали.Уровень());
								ТабДок.Присоединить(ОбластьДетальныхЗаписей2);
								
								ТЗ[ин].ИтогАвто=ТЗ[ин].ИтогАвто + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбъект=ТЗ[ин].ИтогОбъект + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбщий=ТЗ[ин].ИтогОбщий + ВыборкаДетали.КоличествоОборот;
							Иначе
								//ТабДок.Присоединить(ОбластьПусто, ВыборкаДетали.Уровень());
								ТабДок.Присоединить(ОбластьПусто);
								
							КонецЕсли; 
						КонецЦикла; 
						
						ОбластьДетальныхЗаписей3.Параметры.Заполнить(ВыборкаДетали);
						
						//ТабДок.Присоединить(ОбластьДетальныхЗаписей3, ВыборкаДетали.Уровень());
						ТабДок.Присоединить(ОбластьДетальныхЗаписей3);
						
					КонецЦикла;  // по путевым листам
					
				КонецЦикла;      // по параметрам   выработки
				
				ОбластьТС1.Параметры.Заполнить(ВыборкаТС);
				
				//ТабДок.Вывести(ОбластьТС1, ВыборкаТС.Уровень());
				ТабДок.Вывести(ОбластьТС1, 2);
				
				Для ин=0 По ТЗ.Количество()-1 Цикл
					ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогАвто;
					
					//ТабДок.Присоединить(ОбластьТС2, ВыборкаТС.Уровень());
					ТабДок.Присоединить(ОбластьТС2);
					
				КонецЦикла; 
				ОбластьТС3.Параметры.Заполнить(ВыборкаТС);
				
				//ТабДок.Присоединить(ОбластьТС3, ВыборкаТС.Уровень());
				ТабДок.Присоединить(ОбластьТС3);
				
			КонецЦикла; // по автомобилям
			
			ОбластьОбъектСтроительства1.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Вывести(ОбластьОбъектСтроительства1, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительства1, 1);
			
			Для ин=0 По ТЗ.Количество()-1 Цикл
				ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогОбъект;
				
				//ТабДок.Присоединить(ОбластьТС2, ВыборкаОбъектСтроительства.Уровень());
				ТабДок.Присоединить(ОбластьТС2);
			КонецЦикла; 
			ОбластьТС3.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Присоединить(ОбластьТС3, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Присоединить(ОбластьТС3);
			
		КонецЦикла;     // по объектам
		
	Иначе
		
		Пока ВыборкаОбъектСтроительства.Следующий() Цикл       // цикл по объекту строительства
			ОбластьОбъектСтроительстваЗаголовок.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			//ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, 1);
			
			ВыборкаТС = ВыборкаОбъектСтроительства.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ТЗ.ЗаполнитьЗначения(0,"ИтогОбъект");
			
			Пока ВыборкаТС.Следующий() Цикл                    // цикл по автомобилям
				ВыборкаПараметрВыработки = ВыборкаТС.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				ТЗ.ЗаполнитьЗначения(0,"ИтогАвто");
				Пока ВыборкаПараметрВыработки.Следующий() Цикл
					ВыборкаДетали = ВыборкаПараметрВыработки.Выбрать();
					
					Пока ВыборкаДетали.Следующий() Цикл       // цикл по путевым листам
						ОбластьДетальныхЗаписей1.Параметры.Номер = ВыборкаДетали.ПутЛист.Номер;
						ОбластьДетальныхЗаписей1.Параметры.Дата = ВыборкаДетали.ПутЛист.Дата;
						ОбластьДетальныхЗаписей1.Параметры.ТС = Строка(ВыборкаДетали.ТС);
						
						//ТабДок.Вывести(ОбластьДетальныхЗаписей1, ВыборкаДетали.Уровень());
						ТабДок.Вывести(ОбластьДетальныхЗаписей1, 3);
						
						Для ин=0 По ТЗ.Количество()-1 Цикл
							Если ТЗ[ин].ПараметрВыработки=ВыборкаДетали.ПараметрВыработки Тогда
								ОбластьДетальныхЗаписей2.Параметры.Заполнить(ВыборкаДетали);
								
								//ТабДок.Присоединить(ОбластьДетальныхЗаписей2, ВыборкаДетали.Уровень());
								ТабДок.Присоединить(ОбластьДетальныхЗаписей2);
								
								ТЗ[ин].ИтогАвто=ТЗ[ин].ИтогАвто + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбъект=ТЗ[ин].ИтогОбъект + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбщий=ТЗ[ин].ИтогОбщий + ВыборкаДетали.КоличествоОборот;
								
							Иначе
								//ТабДок.Присоединить(ОбластьПусто, ВыборкаДетали.Уровень());
								//ТабДок.Присоединить(ОбластьПусто);
								ТабДок.Присоединить(ОбластьПусто);
								
							КонецЕсли; 
						КонецЦикла; 
						
						ОбластьДетальныхЗаписей3.Параметры.Заполнить(ВыборкаДетали);
						ТабДок.Присоединить(ОбластьДетальныхЗаписей3, ВыборкаДетали.Уровень());
						
					КонецЦикла;  // по путевым листам
				КонецЦикла;      // по параметрам   выработки
				ОбластьТС1.Параметры.Заполнить(ВыборкаТС);
				
				//ТабДок.Вывести(ОбластьТС1, ВыборкаТС.Уровень());
				ТабДок.Вывести(ОбластьТС1, 2);
				
				Для ин=0 По ТЗ.Количество()-1 Цикл
					ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогАвто;
					//ТабДок.Присоединить(ОбластьТС2, ВыборкаТС.Уровень());
					ТабДок.Присоединить(ОбластьТС2);
					
				КонецЦикла; 
				
				ОбластьТС3.Параметры.Заполнить(ВыборкаТС);
				//ТабДок.Присоединить(ОбластьТС3, ВыборкаТС.Уровень());
				ТабДок.Присоединить(ОбластьТС3);
				
			КонецЦикла;    // по автомобилям
			
			ОбластьОбъектСтроительства1.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Вывести(ОбластьОбъектСтроительства1, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительства1, 1);
			
			Для ин=0 По ТЗ.Количество()-1 Цикл
				ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогОбъект;
				//ТабДок.Присоединить(ОбластьТС2, ВыборкаОбъектСтроительства.Уровень());
				ТабДок.Присоединить(ОбластьТС2);
			КонецЦикла; 
			ОбластьТС3.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Присоединить(ОбластьТС3, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Присоединить(ОбластьТС3);
			
		КонецЦикла;     // по объектам
	КонецЕсли;	 
	
	//ТабДок.Вывести(ОбластьОбщийИтог1, ВыборкаОбщийИтог.Уровень());
	ТабДок.Вывести(ОбластьОбщийИтог1, 0);
	
	Для ин=0 По ТЗ.Количество()-1 Цикл
		ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогОбщий;
		
		//ТабДок.Присоединить(ОбластьТС2, ВыборкаОбщийИтог.Уровень());
		ТабДок.Присоединить(ОбластьТС2);
	КонецЦикла; 
	ОбластьОбщийИтог2.Параметры.Заполнить(ВыборкаОбщийИтог);
	
	//ТабДок.Присоединить(ОбластьОбщийИтог2, ВыборкаОбщийИтог.Уровень());
	ТабДок.Присоединить(ОбластьОбщийИтог2);
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ОбластьПодвал.Параметры.Контрагент =Контрагент.НаименованиеПолное;
	ОбластьПодвал.Параметры.Исполнитель = Организация.НаименованиеПолное;
	Если ФлагФаксимиле Тогда
		Руководители = уатОбщегоНазначенияТиповые.уатОтветственныеЛицаОрганизаций(Организация, ДатаНач);
		ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
		ПодписиИФаксимиле.Вставить("ПодписьРуководителя", ?(Руководители <> Неопределено, Руководители.РуководительСсылка, Справочники.ФизическиеЛица.ПустаяСсылка()));
		ПодписиИФаксимиле.Вставить("ПечатьОрганизации", "ФайлФаксимильнаяПечать");
		уатОбщегоНазначения.ЗаполнитьФаксимилеВОбластиМакета(ОбластьПодвал, Организация, ПодписиИФаксимиле, Ошибки);
	Конецесли;

	ТабДок.Вывести(ОбластьПодвал);
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РЕЕСТР";
	ТабДок.ФиксацияСверху = 9;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

КонецПроцедуры

#КонецОбласти
