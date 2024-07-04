////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции расчета по формулам
// 
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьПустоеДеревоОператоров() Экспорт
	
	Дерево = Новый ДеревоЗначений();
	Дерево.Колонки.Добавить("Наименование");
	Дерево.Колонки.Добавить("Оператор");
	Дерево.Колонки.Добавить("Сдвиг", Новый ОписаниеТипов("Число"));
	
	Возврат Дерево;
	
КонецФункции

Функция ПостроитьДеревоОператоров() Экспорт
	Дерево = ПолучитьПустоеДеревоОператоров();
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("en='Operators';ru='Операторы'"));
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("en='Logical operators and constants';ru='Логические операторы и константы'"));
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<", " < ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, ">", " > ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<=", " <= ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, ">=", " >= ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "=", " = ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "<>", " <> ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='I';ru='И'"), " И ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Or';ru='ИЛИ'"), " ИЛИ ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='NOT';ru='НЕ'"), " НЕ ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='ИСТИНА';ru='ИСТИНА'"), " ИСТИНА ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='ЛОЖЬ';ru='ЛОЖЬ'"), " ЛОЖЬ ");
	
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, НСтр("en='Function';ru='Функции'"));
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Max';ru='Максимум'"), "Макс(,)", 2);
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Minimum';ru='Минимум'"), "Мин(,)", 2);
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Round off';ru='Округление'"), "Окр(,)", 2);
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='whole part';ru='Целая часть'"), "Цел()", 1);
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Condition';ru='Условие'"), "?(,,)", 3);
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, НСтр("en='Value is filled in';ru='Значение заполнено'"), "ЗначениеЗаполнено()", 1);
	
	Возврат Дерево;
КонецФункции

Функция ДобавитьГруппуОператоров(Дерево, Наименование) Экспорт
	
	НоваяГруппа = Дерево.Строки.Добавить();
	НоваяГруппа.Наименование = Наименование;
	
	Возврат НоваяГруппа;
	
КонецФункции

Функция ДобавитьОператор(Дерево, Родитель = Неопределено, Наименование, Оператор = Неопределено, Сдвиг = 0) Экспорт
	
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Оператор = ?(ЗначениеЗаполнено(Оператор), Оператор, Наименование);
	НоваяСтрока.Сдвиг = Сдвиг;
	
	Возврат НоваяСтрока;
	
КонецФункции

Функция ПолучитьСтандартноеДеревоОператоров() Экспорт
	
	Дерево = ПолучитьПустоеДеревоОператоров();
	ГруппаОператоров = уатРаботаСФормулами.ДобавитьГруппуОператоров(Дерево, НСтр("en='Operators';ru='Операторы'"));
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	уатРаботаСФормулами.ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	Возврат Дерево;
	
КонецФункции

Функция ВычислитьФормулу(ТекстРасчета) Экспорт
	
	Возврат Вычислить(ТекстРасчета);
	
КонецФункции

Функция ПолучитьТекстОперандаДляВставки(Операнд, ТипСкобок = "[") Экспорт
	
	Если ТипСкобок = "[" Тогда
		Возврат "[" + Операнд + "]";
	Иначе
		Возврат "{" + Операнд + "}";
	КонецЕсли;
	
КонецФункции // ПолучитьТекстОперандаДляВставки()

Функция ПроверитьФормулу(Формула, Операнды, ПараметрыВыработки, Знач Поле = "", Знач СообщениеОбОшибке = "") Экспорт
	
	Результат = Истина;
	
	ТекстРасчета = Формула;
	Если ЗначениеЗаполнено(ТекстРасчета) Тогда
		
		Для Каждого Операнд Из Операнды Цикл
			ТекстРасчета = СтрЗаменить(ТекстРасчета, ПолучитьТекстОперандаДляВставки(Операнд, "["), " 1 ");
		КонецЦикла;
		
		Для Каждого ПараметрВыработки Из ПараметрыВыработки Цикл
			ТекстРасчета = СтрЗаменить(ТекстРасчета, ПолучитьТекстОперандаДляВставки(ПараметрВыработки, "{"), " 1 ");
		КонецЦикла;
		
		Попытка
			
			РезультатРасчета = Вычислить(ТекстРасчета);
			
		Исключение
		
			Результат = Ложь;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ПроверитьФормулу()

Функция ПостроитьСписокОперандов(СпособРасчетаПараметровВыработки) Экспорт
	
	Реквизиты = Новый Массив();	
	
	Если СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоШапке Тогда
		РеквизитыШапки = Метаданные.Документы.уатПутевойЛист.Реквизиты;
		Реквизиты.Добавить(РеквизитыШапки.ДатаВыезда.Имя);
		Реквизиты.Добавить(РеквизитыШапки.ДатаВозвращения.Имя);
		Реквизиты.Добавить(РеквизитыШапки.СпидометрВыезда.Имя);
		Реквизиты.Добавить(РеквизитыШапки.СпидометрВозвращения.Имя);
		Реквизиты.Добавить(РеквизитыШапки.Температура.Имя);
	ИначеЕсли СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоЗаданию Тогда
		Для Каждого Реквизит Из Метаданные.Документы.уатПутевойЛист.ТабличныеЧасти.Задание.Реквизиты Цикл
			Если Реквизит.Имя = "Подразделение" ИЛИ Реквизит.Имя = "ОбъектСтроительства" 
				 ИЛИ Реквизит.Имя = "Маршрут" ИЛИ Реквизит.Имя = "Контрагент" 
				 ИЛИ Реквизит.Имя = "Выполнено" Тогда
				Продолжить;
			Иначе
				Реквизиты.Добавить(Реквизит.Имя);
			КонецЕсли;
		КонецЦикла; 
	ИначеЕсли СпособРасчетаПараметровВыработки = Перечисления.уатСпособРасчетаПараметровВыработки.ПоТТД Тогда
		Для Каждого Реквизит Из Метаданные.Документы.уатТТД.ТабличныеЧасти.Выработка.Реквизиты Цикл
			Если Реквизит.Имя = "Подразделение" ИЛИ Реквизит.Имя = "ОбъектСтроительства" 
				 ИЛИ Реквизит.Имя = "ВремяПрибытия" ИЛИ Реквизит.Имя = "ВремяУбытия"
				 ИЛИ Реквизит.Имя = "СпидометрПрибытия" ИЛИ Реквизит.Имя = "СпидометрУбытия"
				 ИЛИ Реквизит.Имя = "УсловиеРаботы" ИЛИ Реквизит.Имя = "ПараметрВыработки"
				 ИЛИ Реквизит.Имя = "ЕдиницаИзмерения" ИЛИ Реквизит.Имя = "СпособОпределенияМассы"
				 ИЛИ Реквизит.Имя = "Цена" ИЛИ Реквизит.Имя = "Сумма"
				 ИЛИ Реквизит.Имя = "ВидУпаковки" ИЛИ Реквизит.Имя = "КоличествоМест"
				 ИЛИ Реквизит.Имя = "Маршрут" ИЛИ Реквизит.Имя = "ПутЛист" Тогда
				Продолжить;
			Иначе
				Реквизиты.Добавить(Реквизит.Имя);
			КонецЕсли;
		КонецЦикла; 
    КонецЕсли;
	
	Возврат Реквизиты;
	
КонецФункции

#КонецОбласти
