

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)  
	
	Если НЕ Параметры.Свойство("Материалы") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// начало блока стандартных операций
	ДопПараметрыОткрытие = Новый Структура("ИмяФормы", ИмяФормы);
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	// конец блока стандартных операций 
	
	Если Параметры.Свойство("РемонтВАвтосервисе") Тогда
		ФлагРемонтВАвтосервисе = Параметры.РемонтВАвтосервисе;
	КонецЕсли; 
	
	Если Параметры.Свойство("СкладОстатков") И ЗначениеЗаполнено(Параметры.СкладОстатков) Тогда  
		СкладОстатков = Параметры.СкладОстатков;
	КонецЕсли; 
	
	Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда
		Организация = Параметры.Организация; 
	КонецЕсли;
	
	Если Параметры.Свойство("Основание") И ЗначениеЗаполнено(Параметры.Основание) Тогда
		Основание = Параметры.Основание; 
	КонецЕсли;
	
	Если Параметры.Свойство("Материалы") Тогда
		ЗаполнитьТаблицуМатериаловНаСервере(Параметры.Материалы);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("en='Immediate opening for this object is prohibited!';ru='Непосредственное открытие для данного объекта запрещено!'"), 10);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти   

#Область ОбработчикиСобытийЭлементовШапкиФормы 

&НаКлиенте
Процедура ЗаполнитьМатериалыПриИзменении(Элемент)
	ЗаполнитьТаблицуМатериаловНаСервере();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы   

&НаКлиенте
Процедура ПеренестиВДокумент(Команда) 
	
	ПараметрыФормы = Новый Структура("МатериалыИРаботыВыбраны, Материалы, ДокументОснование", Истина, Материалы, Основание);
	ОткрытьФорму("Документ.уатСчетНаОплатуПоставщика.Форма.ФормаДокумента", ПараметрыФормы,, Новый УникальныйИдентификатор);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции 

&НаСервере
Процедура ЗаполнитьТаблицуМатериаловНаСервере(ТаблицаМатериалов = Неопределено)
	
	Если ТаблицаМатериалов <> Неопределено Тогда
		ТЗМатериалы = ТаблицаМатериалов.Выгрузить(); 
	Иначе 
		ТЗМатериалы = Материалы.Выгрузить()
	КонецЕсли;
	Материалы.Очистить();
	
	Если ФлагРемонтВАвтосервисе Тогда 
		Для Каждого ТекСтрока Из ТЗМатериалы Цикл
			НовСтрока = Материалы.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрока);
			НовСтрока.Количество = ТекСтрока.ПоЗаявкеНаРемонт;
		КонецЦикла;
	Иначе
		
		Если ЗначениеЗаполнено(Организация) Тогда
			ВедетсяУчетПоСкладам = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация,
			ПланыВидовХарактеристик.уатПраваИНастройки.ВестиСкладскойУчетУАТ)
		Иначе
			ВедетсяУчетПоСкладам = Ложь;
		КонецЕсли;
		
		Запрос = Новый Запрос();
		
		Запрос.Текст = "ВЫБРАТЬ
		|	ТЗМатериалы.Номенклатура КАК Номенклатура,
		|	ТЗМатериалы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТЗМатериалы.ПоЗаявкеНаРемонт КАК ПоЗаявкеНаРемонт
		|ПОМЕСТИТЬ ТЗМатериалы
		|ИЗ
		|	&ТЗМатериалы КАК ТЗМатериалы
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЗМатериалы.Номенклатура КАК Номенклатура,
		|	ТЗМатериалы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТЗМатериалы.ПоЗаявкеНаРемонт КАК ПоЗаявкеНаРемонт,
		|	ЕСТЬNULL(уатПартииТоваровНаСкладахОстатки.КоличествоОстаток, 0) КАК ОстатокНаСкладе,
		|	ВЫБОР
		|		КОГДА &ЗаполнитьМатериалы = 0
		|			ТОГДА ТЗМатериалы.ПоЗаявкеНаРемонт
		|		ИНАЧЕ ВЫБОР
		|				КОГДА ТЗМатериалы.ПоЗаявкеНаРемонт - ЕСТЬNULL(уатПартииТоваровНаСкладахОстатки.КоличествоОстаток, 0) < 0
		|					ТОГДА 0
		|				ИНАЧЕ ТЗМатериалы.ПоЗаявкеНаРемонт - ЕСТЬNULL(уатПартииТоваровНаСкладахОстатки.КоличествоОстаток, 0)
		|			КОНЕЦ
		|	КОНЕЦ КАК Количество
		|ИЗ
		|	ТЗМатериалы КАК ТЗМатериалы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатПартииТоваровНаСкладах.Остатки(
		|				,
		|				Номенклатура В
		|						(ВЫБРАТЬ
		|							ТЗМатериалы.Номенклатура КАК Номенклатура
		|						ИЗ
		|							ТЗМатериалы КАК ТЗМатериалы)
		|					И ВЫБОР
		|						КОГДА &ВестиСкладскойУчет
		|							ТОГДА ВЫБОР
		|									КОГДА &Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|										ТОГДА Склад = &Склад
		|									ИНАЧЕ ИСТИНА
		|								КОНЕЦ
		|						ИНАЧЕ ИСТИНА
		|					КОНЕЦ) КАК уатПартииТоваровНаСкладахОстатки
		|		ПО ТЗМатериалы.Номенклатура = уатПартииТоваровНаСкладахОстатки.Номенклатура";
		
		Запрос.УстановитьПараметр("ВестиСкладскойУчет", ВедетсяУчетПоСкладам);
		Запрос.УстановитьПараметр("Склад", СкладОстатков);
		Запрос.УстановитьПараметр("ТЗМатериалы", ТЗМатериалы); 
		Запрос.УстановитьПараметр("ЗаполнитьМатериалы", ЗаполнитьМатериалы);
		
		Выборка = Запрос.Выполнить().Выбрать(); 
		
		Пока Выборка.Следующий() Цикл 
			НовСтрока = Материалы.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Выборка);	
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость() 
	
	Если ФлагРемонтВАвтосервисе Тогда
		Элементы.ЗаполнитьМатериалы.Доступность = Ложь;
		Элементы.МатериалыОстатокНаСкладе.Видимость = Ложь;
		Элементы.СкладОстатков.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти