
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Ложь;
	
	НачатьТранзакцию();
	Попытка
		ДатаПоследнегоИзменения = ТекущаяДатаСеанса();
	
		ДвоичныеДанныеКэша = РегистрыСведений.ОператорыЭДО.ПолучитьМакет("ОператорыЭДО");
		ДанныеКэша = СервисНастроекЭДО.ОбработкаРезультатаКаталогОператоров(ДвоичныеДанныеКэша);
		
		Если ДанныеКэша <> Неопределено Тогда
			СервисНастроекЭДО.ОбновитьДанныеОператоровЭлектронногоДокументооборота(ДанныеКэша, ДатаПоследнегоИзменения);
		КонецЕсли;
		
		ОбработкаЗавершена = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = НСтр("ru = 'Не удалось заполнить кеши операторов ЭДО по причине:'") + Символы.ПС 
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюНачальноеЗаполнение(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти
	
#Область СлужебныйПрограммныйИнтерфейс

Функция ИнформацияОбОператореЭДОУчетнойЗаписи(УчетнаяЗапись) Экспорт
	
	ТаблицаОператоровЭДО = ТаблицаОператоровЭДО();
	ОператорЭДО = Неопределено;
	
	Для Каждого Оператор Из ТаблицаОператоровЭДО Цикл
		
		Если Лев(ВРег(УчетнаяЗапись), СтрДлина(Оператор.ИдентификаторОператора)) = ВРег(Оператор.ИдентификаторОператора) Тогда
			ОператорЭДО = Оператор.ИдентификаторОператора;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ОператорЭДО) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОператорыЭДО.ИдентификаторОператора КАК ИдентификаторОператора,
		|	ОператорыЭДО.Представление КАК Представление,
		|	ОператорыЭДО.ИНН КАК ИНН,
		|	ОператорыЭДО.КПП КАК КПП,
		|	ОператорыЭДО.ОГРН КАК ОГРН,
		|	ОператорыЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
		|	ОператорыЭДО.ОтпечатокСертификата КАК ОтпечатокСертификата,
		|	ОператорыЭДО.ДоступноПодключениеЧерез1С КАК ДоступноПодключениеЧерез1С,
		|	ОператорыЭДО.ОтправлятьДополнительныеСведения КАК ОтправлятьДополнительныеСведения,
		|	ОператорыЭДО.СсылкаНаСтраницуТехническойПоддержки КАК СсылкаНаСтраницуТехническойПоддержки
		|ИЗ
		|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО
		|ГДЕ
		|	ОператорыЭДО.ИдентификаторОператора = &ОператорЭДО";
	
	Запрос.УстановитьПараметр("ОператорЭДО", ОператорЭДО);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ТаблицаДанныхОбОператореЭДО = РезультатЗапроса.Выгрузить();
	
	Результат = Неопределено;
	
	Если ТаблицаДанныхОбОператореЭДО.Количество() > 0 Тогда
		Результат = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаДанныхОбОператореЭДО[0]);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает данные оператора ЭДО по идентификатору
Функция АктуальныеДанныеОператораЭДО(ОператорЭДО) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОператорыЭДО.ИНН КАК ИНН,
		|	ОператорыЭДО.КПП КАК КПП,
		|	ОператорыЭДО.ОГРН КАК ОГРН,
		|	ОператорыЭДО.ОтпечатокСертификата КАК Сертификат,
		|	ОператорыЭДО.СпособОбменаЭД КАК СпособОбмена,
		|	ОператорыЭДО.ИдентификаторОператора КАК Код,
		|	ОператорыЭДО.Представление КАК Наименование
		|ИЗ
		|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО
		|ГДЕ
		|	ОператорыЭДО.ИдентификаторОператора = &ИдентификаторОператора";
	
	Запрос.УстановитьПараметр("ИдентификаторОператора", ОператорЭДО);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтрокаРезультат = РезультатЗапроса.Выгрузить()[0];
	
	Возврат ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаРезультат);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаОператоровЭДО()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОператорыЭДО.ИдентификаторОператора КАК ИдентификаторОператора,
		|	ОператорыЭДО.Представление КАК Представление,
		|	ОператорыЭДО.СпособОбменаЭД КАК СпособОбменаЭД,
		|	ОператорыЭДО.СсылкаНаСтраницуТехническойПоддержки КАК СсылкаНаСтраницуТехническойПоддержки
		|ИЗ
		|	РегистрСведений.ОператорыЭДО КАК ОператорыЭДО";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
