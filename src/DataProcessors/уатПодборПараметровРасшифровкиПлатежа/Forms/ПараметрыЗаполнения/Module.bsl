
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДокументСсылка = Параметры.ДокументСсылка;
	КурсДокумента = Параметры.КурсДокумента;
	КратностьДокумента = Параметры.КратностьДокумента;
	ТипЗадолженности = Параметры.ТипЗадолженности;
	Контрагент = Параметры.Контрагент;
	БанковскийСчетКасса = Параметры.БанковскийСчетКасса;
	Организация = Параметры.Организация;
	ВалютаДокумента = Параметры.ВалютаДокумента;
	ДатаДок = Параметры.ДатаДок;
	СуммаДляПодбора = Параметры.СуммаДляПодбора;
	ПлатежПоСуммеВзаиморасчетов = Параметры.ПлатежПоСуммеВзаиморасчетов;
	ЕстьПодбор = Параметры.ЕстьПодбор;
		
	Для Каждого ТекСтрока Из Параметры.РасшифровкаПлатежа Цикл
		НовСтрока = ДокументРасшифровкаПлатежа.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, ТекСтрока);
	КонецЦикла;
	
	ВосстановитьНастройкиИОтборы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.СпособЗаполнения = "" Тогда Объект.СпособЗаполнения = "ФИФО" КонецЕсли;
	
	ЭлементПоЗаявкам = Элементы.СпособЗаполнения.СписокВыбора.НайтиПоЗначению(1);
	Если Не ЭлементПоЗаявкам = Неопределено Тогда 
		Если ТипЗадолженности = "<0" Тогда
			ЭлементПоЗаявкам.Представление = НСтр("en='On expenditure requests';ru='По заявкам на расходование средств'");
		Иначе 
			ЭлементПоЗаявкам.Представление = НСтр("en='On the planned cash flow';ru='По планируемым поступлениям денежных средств'");
		КонецЕсли;
	КонецЕсли;
	
	ЭлементПорядокФИФО = Элементы.ПорядокПогашения.СписокВыбора.НайтиПоЗначению("ФИФО");
	Если Не ЭлементПорядокФИФО = Неопределено Тогда 
		Если ТипЗадолженности = "<0" Тогда
			ЭлементПорядокФИФО.Представление = НСтр("en='Increase dates of planned expense';ru='По возрастанию даты планируемого расхода'");
		Иначе 
			ЭлементПорядокФИФО.Представление = НСтр("en='Planned admission of date ascending';ru='По возрастанию даты планируемого поступления'");
		КонецЕсли;
	КонецЕсли;
	
	ЭлементПорядокЛИФО = Элементы.ПорядокПогашения.СписокВыбора.НайтиПоЗначению("ЛИФО");
	Если Не ЭлементПорядокЛИФО = Неопределено Тогда 
		Если ТипЗадолженности = "<0" Тогда
			ЭлементПорядокЛИФО.Представление = НСтр("en='On descending date of planned expense';ru='По убыванию даты планируемого расхода'");
		Иначе 
			ЭлементПорядокЛИФО.Представление = НСтр("en='Descending date of planned receipt';ru='По убыванию даты планируемого поступления'");
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособЗаполненияПриИзменении(Элемент)
	
	Если Булево(СпособЗаполнения) И Объект.СпособЗаполнения = "ТЧ" Тогда
		Объект.СпопобЗаполнения = "ФИФО";
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПоСуммеПлатежаПриИзменении(Элемент)
	
	СохранитьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПостроительОтбораДоговоровНастройкиОтборПриИзменении(Элемент)
	
	СохранитьНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДействиеВыполнить(Команда)
	
	Если Не Объект.СпособЗаполнения = "ТЧ" Тогда
		
		Если Не ПустаяТЧ() Тогда
			
			ТекстВопроса = НСтр("en='Before filling the datasheet portion will be cleared. Fill?';ru='Перед заполнением табличная часть будет очищена. Заполнить?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("ДействиеВыполнитьЗавершение", ЭтотОбъект),
				ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да,);
            Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДействиеВыполнитьФрагмент();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Отбирает неоплаченные задолженности из сформированной таблицы для подбора.
//
&НаСервере
Процедура СформироватьСписокДолгов()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДокументСсылка", ДокументСсылка);
	СтруктураПараметров.Вставить("Организация", Организация);
	СтруктураПараметров.Вставить("Контрагент", Контрагент);
	СтруктураПараметров.Вставить("ВалютаДокумента", ВалютаДокумента);
	СтруктураПараметров.Вставить("КурсДокумента", КурсДокумента);
	СтруктураПараметров.Вставить("КратностьДокумента", КратностьДокумента);
	СтруктураПараметров.Вставить("ТипЗадолженности", ТипЗадолженности);
	СтруктураПараметров.Вставить("ДатаДок", ДатаДок);
	СтруктураПараметров.Вставить("ЕстьПодбор", ЕстьПодбор);
	СтруктураПараметров.Вставить("ДокументРасшифровкаПлатежа", ДокументРасшифровкаПлатежа.Выгрузить());
	
	мсвОтборыПоДоговорам = Новый Массив;
	Для Каждого ТекОтбор Из ПостроительОтбораДоговоров.Настройки.Отбор.Элементы Цикл 
		Если Не ТекОтбор.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураСтроки = Новый Структура("ВидСравнения, ЛевоеЗначение, ПравоеЗначение");
		ЗаполнитьЗначенияСвойств(СтруктураСтроки, ТекОтбор);
	КонецЦикла;
	СтруктураПараметров.Вставить("ОтборыПоДоговорам", мсвОтборыПоДоговорам);
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Обработки.уатПодборПараметровРасшифровкиПлатежа.СформироватьСписокДолгов(ОбработкаОбъект, СтруктураПараметров);
	ЗначениеВРеквизитФормы(ОбработкаОбъект, "Объект");
	
КонецПроцедуры // СформироватьСписокДолгов() 

// Процедура формирует список долгов в развёрнутом виде
//
// Параметры:
//	ПодборПоСуммеПлатежа - флаг использования подбора по сумме платежа
//	КурсПоДоговору - флаг учёта курса в разрезе договоров
//
&НаСервере
Процедура ЗаполнитьРасшифровкуПоДолгам(ПодборПоСуммеПлатежа=Истина,КурсПоДоговору=Истина)
	
	СформироватьСписокДолгов();
	
	СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(),"ОсновнаяСтавкаНДС");
	
	ВсегоПлатежей = 0;
	
	РеглУчет = Истина;
	
	Если Не Объект.СпособЗаполнения = "ТЧ" Тогда
		
		Если Объект.СпособЗаполнения = "ЛИФО" Тогда
			
			Объект.РасшифровкаПлатежа.Сортировать("ДатаВозникновения Убыв");
			
		КонецЕсли;
		
		Для Каждого СтрокаДолг Из Объект.РасшифровкаПлатежа Цикл
			
			Если Объект.ПодбиратьСумму Тогда
				
				Если ВсегоПлатежей+СтрокаДолг.СуммаПлатежа <= Объект.СуммаДляПодбора Тогда
					
					СуммаПлатежа        = СтрокаДолг.СуммаПлатежа;
					СуммаВзаиморасчетов = СтрокаДолг.СуммаВзаиморасчетов;
					
					ВсегоПлатежей = ВсегоПлатежей+СуммаПлатежа;
					
				ИначеЕсли ВсегоПлатежей < Объект.СуммаДляПодбора Тогда
					
					СуммаПлатежа        = Объект.СуммаДляПодбора-ВсегоПлатежей;
					СуммаВзаиморасчетов = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(СуммаПлатежа,
					                                                ВалютаДокумента,
					                                                СтрокаДолг.ДоговорКонтрагента.ВалютаВзаиморасчетов,
					                                                КурсДокумента,СтрокаДолг.КурсВзаиморасчетов,
					                                                КратностьДокумента,СтрокаДолг.КратностьВзаиморасчетов);
					ВсегоПлатежей = ВсегоПлатежей + СуммаПлатежа;
					
				Иначе
					
					Прервать;
					
				КонецЕсли;
				
			Иначе
				
				СуммаПлатежа        = СтрокаДолг.СуммаПлатежа;
				СуммаВзаиморасчетов = СтрокаДолг.СуммаВзаиморасчетов;
				
			КонецЕсли;
			
			СтрокаПлатеж = ДокументРасшифровкаПлатежа.Добавить();
			СтрокаПлатеж.ДоговорКонтрагента      = СтрокаДолг.ДоговорКонтрагента;
			СтрокаПлатеж.Сделка                  = СтрокаДолг.Сделка;
			СтрокаПлатеж.СуммаПлатежа            = СуммаПлатежа;
			СтрокаПлатеж.ВалютаВзаиморасчетов    = СтрокаДолг.Валюта;
			СтрокаПлатеж.КурсВзаиморасчетов      = СтрокаДолг.КурсВзаиморасчетов;
			СтрокаПлатеж.КратностьВзаиморасчетов = СтрокаДолг.КратностьВзаиморасчетов;
			СтрокаПлатеж.СуммаВзаиморасчетов     = СуммаВзаиморасчетов;
			
		КонецЦикла;
		
		Если Объект.ПодбиратьСумму И ВсегоПлатежей<Объект.СуммаДляПодбора Тогда
			
			СтрокаПлатеж = ДокументРасшифровкаПлатежа.Добавить();
			СтрокаПлатеж.СуммаПлатежа = Объект.СуммаДляПодбора-ВсегоПлатежей;
			
			ДоговорПоУмолчанию = ПолучитьДоговорПоУмолчанию();
			
			Если Не ЗначениеЗаполнено(ДоговорПоУмолчанию) Тогда
				
				СтрокаПлатеж.КурсВзаиморасчетов      = 1;
				СтрокаПлатеж.КратностьВзаиморасчетов = 1;
				СтрокаПлатеж.СуммаВзаиморасчетов     = СтрокаПлатеж.СуммаПлатежа;
				
			Иначе
				
				СтрокаПлатеж.ДоговорКонтрагента = ДоговорПоУмолчанию;
				ВалютаВзаиморасчетов = СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов;
				СтруктураКурсаВзаиморасчетов = уатОбщегоНазначенияТиповые.ПолучитьКурсВалюты(ВалютаВзаиморасчетов, ДатаДок);
				
				СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
				СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
				
				СтрокаПлатеж.СуммаВзаиморасчетов = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(СтрокаПлатеж.СуммаПлатежа,
				                        ВалютаДокумента,СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов,
				                        КурсДокумента,СтрокаПлатеж.КурсВзаиморасчетов,
				                        КратностьДокумента,СтрокаПлатеж.КратностьВзаиморасчетов);
				
				Если Метаданные.Справочники.ДоговорыКонтрагентов.Реквизиты.Найти("ОсновнаяСтатьяДвиженияДенежныхСредств") <> Неопределено Тогда
					СтрокаПлатеж.СтатьяДвиженияДенежныхСредств = СтрокаПлатеж.ДоговорКонтрагента.ОсновнаяСтатьяДвиженияДенежныхСредств;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Для Каждого СтрокаПлатеж Из ДокументРасшифровкаПлатежа Цикл
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("ДоговорКонтрагента", СтрокаПлатеж.ДоговорКонтрагента);
			СтруктураОтбора.Вставить("Сделка",             СтрокаПлатеж.Сделка);
			
			СтрокаДолг = Неопределено;
			
			МассивНайденныхСтрок = Объект.РасшифровкаПлатежа.НайтиСтроки(СтруктураОтбора);
			Если МассивНайденныхСтрок.Количество() > 0 Тогда
				// Нашли. Вернем первую найденную строку.
				СтрокаДолг = МассивНайденныхСтрок[0];
			КонецЕсли;
			
			Если Не СтрокаДолг = Неопределено Тогда
				
				КурсВзаиморасчетов      = ?(СтрокаПлатеж.КурсВзаиморасчетов=0,СтрокаДолг.КурсВзаиморасчетов,СтрокаПлатеж.КурсВзаиморасчетов);
				КратностьВзаиморасчетов = ?(СтрокаПлатеж.КратностьВзаиморасчетов=0,СтрокаДолг.КратностьВзаиморасчетов,СтрокаПлатеж.КратностьВзаиморасчетов);
				
				Если Объект.ПодбиратьСумму Тогда
					
					Если ВсегоПлатежей+СтрокаДолг.СуммаПлатежа <= Объект.СуммаДляПодбора Тогда
						
						СтрокаПлатеж.СуммаПлатежа = СтрокаДолг.СуммаПлатежа;
						ВсегоПлатежей             = ВсегоПлатежей+СтрокаДолг.СуммаПлатежа;
						
					ИначеЕсли ВсегоПлатежей<Объект.СуммаДляПодбора Тогда
						
						СтрокаПлатеж.СуммаПлатежа = Объект.СуммаДляПодбора-ВсегоПлатежей;
						ВсегоПлатежей             = Объект.СуммаДляПодбора;
						
					Иначе
						
						Прервать;
						
					КонецЕсли;
					
				Иначе
					
					СтрокаПлатеж.СуммаПлатежа = СтрокаДолг.СуммаПлатежа;
					
				КонецЕсли;
				
				СтрокаПлатеж.СуммаВзаиморасчетов = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(СтрокаПлатеж.СуммаПлатежа,
				                                            ВалютаДокумента,СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов,
				                                            КурсДокумента,КурсВзаиморасчетов,
				                                            КратностьДокумента,КратностьВзаиморасчетов);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого СтрокаПлатеж Из ДокументРасшифровкаПлатежа Цикл
		ЗаполнитьРеквизитыРеглУчета(ДокументСсылка, СтрокаПлатеж, СтавкаНДС);
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьРасшифровкуПоДолгам()

&НаСервере
Функция ПолучитьДоговорПоУмолчанию()
	
	Если ТипЗнч(ДокументСсылка.Ссылка) = Тип("ДокументСсылка.уатПлатежноеПоручениеВходящее")
	 ИЛИ ТипЗнч(ДокументСсылка.Ссылка) = Тип("ДокументСсылка.уатПриходныйКассовыйОрдер") Тогда 
		мВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем;
	ИначеЕсли ТипЗнч(ДокументСсылка.Ссылка) = Тип("ДокументСсылка.уатПлатежноеПоручениеИсходящее")
	 ИЛИ ТипЗнч(ДокументСсылка.Ссылка) = Тип("ДокументСсылка.уатРасходныйКассовыйОрдер") Тогда 
		мВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
	ИначеЕсли ТипЗнч(ДокументСсылка.Ссылка) = Тип("ДокументСсылка.уатЗаявкаНаРасходованиеДС") Тогда
		Если ДокументСсылка.ВидОперации = Перечисления.уатВидыОперацийЗаявкиНаРасходование.ОплатаПоставщику Тогда
			мВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
		Иначе
			мВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее;
		КонецЕсли;
	КонецЕсли;
	
	ДоговорПоУмолчанию = уатЗаполнениеДокументов.ПолучитьОсновнойДоговорКонтрагента(Контрагент, мВидДоговора, Организация);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции // ПолучитьДоговорПоУмолчанию()

// Проставляет реквизиты, необходимые для проведения по регламентированному учету
// Парам.
// ДокументОбъект - документ,содержащий строку платежа
// СтрокаПлатеж - строка платежа
// НДСПоУмолчанию -значение ставки НДС по умолчанию
//
&НаСервере
Процедура ЗаполнитьРеквизитыРеглУчета(ДокументОбъект, СтрокаПлатеж, НДСПоУмолчанию)
	
	// проверяем есть ли в ТЧ поле "Ставка НДС"
	Попытка
		СтавкаНДС_ = СтрокаПлатеж.СтавкаНДС;
	Исключение
		СтавкаНДС_ = Неопределено;
	КонецПопытки;
	
	Если СтавкаНДС_ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаПлатеж.СтавкаНДС.Пустая() Тогда
		СтрокаПлатеж.СтавкаНДС = НДСПоУмолчанию;
	КонецЕсли;
	
	ЗначениеСтавкиНДС     = уатОбщегоНазначенияТиповые.уатПолучитьСтавкуНДС(СтрокаПлатеж.СтавкаНДС);
	СтрокаПлатеж.СуммаНДС = СтрокаПлатеж.СуммаПлатежа * ЗначениеСтавкиНДС / (100 + ЗначениеСтавкиНДС);
	
КонецПроцедуры // ЗаполнитьРеквизитыРеглУчета()

&НаСервере
Процедура ВосстановитьНастройкиИОтборы()
	
	Настройки = ХранилищеНастроекДанныхФорм.Загрузить("Обработка.уатПодборПараметровРасшифровкиПлатежа.Форма.ПараметрыЗаполнения", "ФормаОбработки_Настройки");
	
	СхемаКомпоновкиОтборов = Обработки.уатПодборПараметровРасшифровкиПлатежа.ПолучитьМакет("НастройкиОтбора");
	АдресСКДОтборов = ПоместитьВоВременноеХранилище(СхемаКомпоновкиОтборов, УникальныйИдентификатор);
	ПостроительОтбораДоговоров.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКДОтборов));
	
	Если Не Настройки = Неопределено Или ТипЗнч(Настройки) = Тип("Структура") Тогда 
		ПодборПоСуммеПлатежа = Настройки.ПодборПоСуммеПлатежа;
		Попытка
			ПостроительОтбораДоговоров.ЗагрузитьНастройки(Настройки.ПодборПоДоговорам);
		Исключение
			ПостроительОтбораДоговоров.ЗагрузитьНастройки(СхемаКомпоновкиОтборов.НастройкиПоУмолчанию);
		КонецПопытки;
	Иначе 
		ПостроительОтбораДоговоров.ЗагрузитьНастройки(СхемаКомпоновкиОтборов.НастройкиПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	
	Настройки = Новый Структура("ПодборПоСуммеПлатежа,
	                            |ПодборПоДоговорам");
	
	Настройки.ПодборПоСуммеПлатежа = ПодборПоСуммеПлатежа;
	Настройки.ПодборПоДоговорам    = ПостроительОтбораДоговоров.ПолучитьНастройки();
	
	ХранилищеНастроекДанныхФорм.Сохранить("Обработка.уатПодборПараметровРасшифровкиПлатежа.Форма.ПараметрыЗаполнения", "ФормаОбработки_Настройки", Настройки);
	         
КонецПроцедуры

// Устанавливает видимость панелей настройки
//
&НаКлиенте
Процедура УстановитьВидимость()
	
	Если Булево(СпособЗаполнения) Тогда
		Элементы.ГруппаЗаполнение.ТекущаяСтраница = Элементы.ГруппаЗаполнение.ПодчиненныеЭлементы.ГруппаПоДоговорам;
	Иначе
		Элементы.ГруппаЗаполнение.ТекущаяСтраница = Элементы.ГруппаЗаполнение.ПодчиненныеЭлементы.ГруппаПоЗаявкам;
	КонецЕсли;
	
	ЭлементДляСокрытия = Элементы.СпособЗаполнения.СписокВыбора.НайтиПоЗначению(1);
	Если Не ЭлементДляСокрытия = Неопределено Тогда 
		Элементы.СпособЗаполнения.СписокВыбора.Удалить(ЭлементДляСокрытия);
	КонецЕсли;
	
КонецПроцедуры // УстановитьВидимость()

&НаСервере
Функция ПустаяТЧ()
	
	Если ДокументРасшифровкаПлатежа.Количество() = 0 Тогда 
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // ПустаяТЧ()

&НаСервере
Процедура ОчиститьТЧ()
	
	ДокументРасшифровкаПлатежа.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеВыполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    ОчиститьТЧ();
    
    ДействиеВыполнитьФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ДействиеВыполнитьФрагмент()
    
    ЗаполнитьРасшифровкуПоДолгам(Булево(ПодборПоСуммеПлатежа),Ложь);
    
    Закрыть(ДокументРасшифровкаПлатежа);

КонецПроцедуры

#КонецОбласти
