
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьКомпоновщик();
	
	НачалоПериода = НачалоМесяца(ТекущаяДата());
	КонецПериода  = ТекущаяДата();
	ТСВыбыло      = Ложь;
	флИспользованиеЖТД = ПолучитьФункциональнуюОпцию("уатИспользоватьЖурналыТранспортныхДокументов");
	
	Если Параметры.Свойство("Организация") Тогда
		ОтборОрганизация = Параметры.Организация;
	Иначе
		ОтборОрганизация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			Пользователи.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	КонецЕсли;
	Если флИспользованиеЖТД И Параметры.Свойство("Журнал") Тогда
		ОтборЖурнал = Параметры.Журнал;
		НачалоПериода = ОтборЖурнал.ДатаНачала;
		Если ЗначениеЗаполнено(ОтборЖурнал.ДатаОкончания) Тогда
			КонецПериода = ОтборЖурнал.ДатаОкончания;
		ИначеЕсли КонецПериода < НачалоПериода Тогда
			КонецПериода = ДобавитьМесяц(НачалоПериода, 1);
		КонецЕсли;
	КонецЕсли;
	
	ЭлементОтбораЖурнал = Неопределено;	
	Для Каждого ТекЭлемент Из НастройкиКомпоновки.Настройки.Отбор.Элементы Цикл
		Если ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация")
			И ЗначениеЗаполнено(ОтборОрганизация) Тогда
			
			ТекЭлемент.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ТекЭлемент.ПравоеЗначение = ОтборОрганизация;
			ТекЭлемент.Использование  = Истина;
			
		ИначеЕсли ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Журнал") Тогда
			ЭлементОтбораЖурнал = ТекЭлемент;
						
		КонецЕсли;
	КонецЦикла;
	
	Если ЭлементОтбораЖурнал <> Неопределено Тогда
		Если флИспользованиеЖТД Тогда
			Если ЗначениеЗаполнено(ОтборЖурнал) Тогда
				ЭлементОтбораЖурнал.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				ЭлементОтбораЖурнал.ПравоеЗначение = ОтборЖурнал;
				ЭлементОтбораЖурнал.Использование  = Истина;
			КонецЕсли;
		Иначе
			НастройкиКомпоновки.Настройки.Отбор.Элементы.Удалить(ЭлементОтбораЖурнал);
		КонецЕсли;
	КонецЕсли;
				
	УстановитьИконкуСортировки();
	
	Если Параметры.Свойство("ФормироватьПриОткрытии") Тогда
		СформироватьОтчет();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда 
		Возврат;
	КонецЕсли;
	
	СохранитьНастройки();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	Если НачалоПериода > КонецПериода Тогда
		ТекстСообщения = НСтр("en='Period start date cannot be greater than the period end date';ru='Дата начала периода не может быть больше даты конца периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	СформироватьОтчет();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериод(Команда)
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогПериода.Период.ДатаНачала = НачалоПериода;
	ДиалогПериода.Период.ДатаОкончания = КонецПериода;
	ДиалогПериода.Показать(Новый ОписаниеОповещения("УстановитьПериодЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодЗавершение(Период, ДополнительныеПараметры) Экспорт
	
	Если Не Период = Неопределено Тогда
		НачалоПериода = Период.ДатаНачала;
		КонецПериода = Период.ДатаОкончания;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьОтчета(Команда)
	
	ДокументРезультат.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

&НаКлиенте
Процедура Сортировка(Команда)
	ОткрытьФорму("Отчет.уатЖурналПутЛистов.Форма.ФормаСортировки",, ЭтотОбъект,,,,
	Новый ОписаниеОповещения("СоздатьСортировкуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьОтчет()
	
	ДокументРезультат.Очистить();
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Для Каждого ТекПараметр Из НастройкиКомпоновки.Настройки.ПараметрыДанных.Элементы Цикл 
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ДатаНач") Тогда 
			ТекПараметр.Значение = НачалоПериода;
			ТекПараметр.Использование = Истина;
		КонецЕсли;
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ДатаКон") Тогда 
			ТекПараметр.Значение = ?(КонецПериода = '00010101', '39991231', КонецДня(КонецПериода));
			ТекПараметр.Использование = Истина;
		КонецЕсли;
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ОтображатьВыбывшиеТС") Тогда 
			ТекПараметр.Значение = ТСВыбыло;
			ТекПараметр.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ТекОрганизация = Справочники.Организации.ПустаяСсылка();
	Для Каждого ТекЭлемент Из НастройкиКомпоновки.Настройки.Отбор.Элементы Цикл
		Если ТекЭлемент.Использование И ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация")
			И ТекЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			ТекОрганизация = ТекЭлемент.ПравоеЗначение;
		КонецЕсли;
	КонецЦикла;
	
	// Запонение сортировки
	Для Каждого ТекЭлемент Из НастройкиКомпоновкиСортировка.Настройки.Порядок.Элементы Цикл
		ТекНастройка = НастройкиКомпоновки.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(ТекНастройка, ТекЭлемент);
	КонецЦикла;
	
	Если НастройкиКомпоновкиСортировка.Настройки.Порядок.Элементы.Количество() = 0 Тогда
		ЭлементСортировки = НастройкиКомпоновки.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементСортировки.Поле = Новый ПолеКомпоновкиДанных("ДатаВыезда");
		ЭлементСортировки.Использование = Истина;
		ЭлементСортировки.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Убыв;
	КонецЕсли;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	СхемаКомпоновкиДанных = Отчеты.уатЖурналПутЛистов.ПолучитьМакет("ИсточникНастроекОтбораКомпоновщика");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных();
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
	тблРезультат = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(тблРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Макет = Отчеты.уатЖурналПутЛистов.ПолучитьМакет("Макет");
	
	ОбластьШапкаТаблицыВторойЛист = Макет.ПолучитьОбласть("ШапкаТаблицыВтораяСтраница");
	
	Если ПечататьТитульныйЛист Тогда
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.Организация = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(ТекОрганизация, ТекущаяДата()), "НаименованиеДляПечатныхФорм,ЮридическийАдрес,Телефоны");
		ДокументРезультат.Вывести(ОбластьЗаголовок);
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;	
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	
	ВсегоЛистов = 1;
	ДокументРезультат.НачатьАвтогруппировкуСтрок();

	Для Каждого ВыборкаДетали Из тблРезультат Цикл
		ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");
		ЗаполнитьЗначенияСвойств(ОбластьДетальныхЗаписей.Параметры, ВыборкаДетали);
		ОбластьДетальныхЗаписей.Параметры.ТабельныйНомер = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ВыборкаДетали.ТабельныйНомер);
		ОбластьДетальныхЗаписей.Параметры.ВодительФИО    = уатОбщегоНазначения.уатФИОСотрудникаПолноеСтрокой(ВыборкаДетали.Водитель, ВыборкаДетали.ДатаВыезда);
		
		Если НЕ ДокументРезультат.ПроверитьВывод(ОбластьДетальныхЗаписей) Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			ДокументРезультат.Вывести(ОбластьШапкаТаблицыВторойЛист);
			ВсегоЛистов = ВсегоЛистов + 1;
		КонецЕсли;
		
		ДокументРезультат.Вывести(ОбластьДетальныхЗаписей);
		
		Если ОтображатьВторогоВодителя И ЗначениеЗаполнено(ВыборкаДетали.Водитель2) Тогда
			ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали2");
			ЗаполнитьЗначенияСвойств(ОбластьДетальныхЗаписей.Параметры, ВыборкаДетали);
			ОбластьДетальныхЗаписей.Параметры.ТабельныйНомер2 = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(ВыборкаДетали.ТабельныйНомер2);
			ОбластьДетальныхЗаписей.Параметры.ВодительФИО2    = уатОбщегоНазначения.уатФИОСотрудникаПолноеСтрокой(ВыборкаДетали.Водитель2, ВыборкаДетали.ДатаВыезда);
			
			Если НЕ ДокументРезультат.ПроверитьВывод(ОбластьДетальныхЗаписей) Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументРезультат.Вывести(ОбластьШапкаТаблицыВторойЛист);
				ВсегоЛистов = ВсегоЛистов + 1;
			КонецЕсли;
			
			ДокументРезультат.Вывести(ОбластьДетальныхЗаписей);
		КонецЕсли;
	КонецЦикла;

	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
	Если ПечататьПоследнийЛист Тогда
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
		ОбластьПодвал.Параметры.ДатаПечати = ТекущаяДата();
		ОбластьПодвал.Параметры.ВсегоЛистов = ВсегоЛистов;
		ДокументРезультат.Вывести(ОбластьПодвал);
	КонецЕсли;
				
КонецПроцедуры // СформироватьРезультат()

&НаКлиенте
Процедура СоздатьСортировкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("КоллекцияЭлементовПорядкаКомпоновкиДанных") Тогда
		НастройкиКомпоновкиСортировка.Настройки.Порядок.Элементы.Очистить();
		НастройкиКомпоновки.Настройки.Порядок.Элементы.Очистить();
		Для Каждого ТекЭлемент Из Результат Цикл
			ТекНастройка = НастройкиКомпоновкиСортировка.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(ТекНастройка, ТекЭлемент);	
		КонецЦикла;
		
		СформироватьОтчет();
	КонецЕсли;
	
	УстановитьИконкуСортировки();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИконкуСортировки()
	
	ЕстьСортировка = Ложь;
	
	Для Каждого ТекСтрока Из НастройкиКомпоновкиСортировка.Настройки.Порядок.Элементы Цикл
		Если ТекСтрока.Использование Тогда 
			ЕстьСортировка = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.ФормаСортировка.Картинка = ?(ЕстьСортировка, БиблиотекаКартинок.уатСортировкаУстановлена, БиблиотекаКартинок.уатСортировкаНеУстановлена);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщик()
	МакетКомпоновки = Отчеты.уатЖурналПутЛистов.ПолучитьМакет("ИсточникНастроекОтбораКомпоновщика");
	URLСхемы        = ПоместитьВоВременноеХранилище(МакетКомпоновки, УникальныйИдентификатор);
	
	НастройкиКомпоновки.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
	НастройкиКомпоновки.ЗагрузитьНастройки(МакетКомпоновки.НастройкиПоУмолчанию);
	
	// Сортировка
	СхемаКомпоновкиДанныхСортировка = Отчеты.уатЖурналПутЛистов.ПолучитьМакет("ИсточникНастроекОтбораКомпоновщика");
	АдресСхемыКомпоновкиДанныхСортировка = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанныхСортировка, УникальныйИдентификатор);
	
	НастройкиКомпоновкиСортировка.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанныхСортировка));
	НастройкиКомпоновкиСортировка.ЗагрузитьНастройки(СхемаКомпоновкиДанныхСортировка.НастройкиПоУмолчанию);
	
	НастройкиПорядка = ХранилищеНастроекДанныхФорм.Загрузить("Отчеты.уатЖурналПутЛистов.Форма.ФормаОтчета", "уатЖурналПутЛистов_НастройкиКомпоновщика_Порядок");
	Если НастройкиПорядка <> Неопределено 
		ИЛИ ТипЗнч(НастройкиПорядка) = Тип("ХранилищеЗначения") Тогда 
		
		Для Каждого ТекПорядок Из НастройкиПорядка.Получить().Элементы Цикл 
			НовыйПорядок = НастройкиКомпоновкиСортировка.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйПорядок, ТекПорядок);
		КонецЦикла;
	КонецЕсли;
	
	НастройкиОтчета = ХранилищеНастроекДанныхФорм.Загрузить(
		"Отчеты.уатЖурналПутЛистов.Форма.ФормаОтчета",
		"уатЖурналПутЛистов_Настройки");
	Если ТипЗнч(НастройкиОтчета) = Тип("Структура") Тогда
		Если НастройкиОтчета.Свойство("ПечататьТитульныйЛист") Тогда
			ПечататьТитульныйЛист = НастройкиОтчета.ПечататьТитульныйЛист;
		КонецЕсли;
		Если НастройкиОтчета.Свойство("ПечататьПоследнийЛист") Тогда
			ПечататьПоследнийЛист = НастройкиОтчета.ПечататьПоследнийЛист;
		КонецЕсли;
		Если НастройкиОтчета.Свойство("ТСВыбыло") Тогда
			ТСВыбыло = НастройкиОтчета.ТСВыбыло;
		КонецЕсли;
		Если НастройкиОтчета.Свойство("ОтображатьВторогоВодителя") Тогда
			ОтображатьВторогоВодителя = НастройкиОтчета.ОтображатьВторогоВодителя;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	
	ХранилищеНастроекДанныхФорм.Сохранить("Отчеты.уатЖурналПутЛистов.Форма.ФормаОтчета",
		"уатЖурналПутЛистов_НастройкиКомпоновщика_Порядок",
		Новый ХранилищеЗначения(НастройкиКомпоновкиСортировка.Настройки.Порядок));
		
	НастройкиОтчета = Новый Структура;
	НастройкиОтчета.Вставить("ПечататьТитульныйЛист",     ПечататьТитульныйЛист);
	НастройкиОтчета.Вставить("ПечататьПоследнийЛист",     ПечататьПоследнийЛист);
	НастройкиОтчета.Вставить("ТСВыбыло",                  ТСВыбыло);
	НастройкиОтчета.Вставить("ОтображатьВторогоВодителя", ОтображатьВторогоВодителя);
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Отчеты.уатЖурналПутЛистов.Форма.ФормаОтчета",
		"уатЖурналПутЛистов_Настройки",
		НастройкиОтчета);
КонецПроцедуры

#КонецОбласти
