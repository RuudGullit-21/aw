
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализироватьКомпоновщик();
	
	НачалоПериода = НачалоМесяца(ТекущаяДата());
	КонецПериода  = ТекущаяДата();
		
	Если Параметры.Свойство("Организация") Тогда
		ОтборОрганизация = Параметры.Организация;
	Иначе
		ОтборОрганизация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			Пользователи.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	КонецЕсли;
	Если Параметры.Свойство("Журнал") Тогда
		Журнал = Параметры.Журнал;
		НачалоПериода = Журнал.ДатаНачала;
		Если ЗначениеЗаполнено(Журнал.ДатаОкончания) Тогда
			КонецПериода = Журнал.ДатаОкончания;
		ИначеЕсли КонецПериода < НачалоПериода Тогда
			КонецПериода = ДобавитьМесяц(НачалоПериода, 1);
		КонецЕсли;
	КонецЕсли;
	Для Каждого ТекЭлемент Из НастройкиКомпоновки.Настройки.Отбор.Элементы Цикл
		Если ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") И ЗначениеЗаполнено(ОтборОрганизация) Тогда
			ТекЭлемент.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ТекЭлемент.ПравоеЗначение = ОтборОрганизация;
			ТекЭлемент.Использование  = Истина;
		ИначеЕсли ТекЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Журнал") И ЗначениеЗаполнено(Журнал) Тогда
			ТекЭлемент.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ТекЭлемент.ПравоеЗначение = Журнал;
			ТекЭлемент.Использование  = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Параметры.Свойство("ТолькоПодписанные") Тогда
		ТолькоПодписанные = Параметры.ТолькоПодписанные;
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
		Возврат;
	КонецЕсли;
	
	Если Журнал.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указано значение журнала",, "Журнал");
		Возврат;
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
	ОткрытьФорму("Отчет.уатЖурналУчетаПоказанийОдометра.Форма.ФормаСортировки",, ЭтотОбъект,,,,
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
			ТекПараметр.Значение      = НачалоПериода;
			ТекПараметр.Использование = Истина;
		КонецЕсли;
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ДатаКон") Тогда 
			ТекПараметр.Значение      = ?(КонецПериода = '00010101', '39991231', КонецДня(КонецПериода));
			ТекПараметр.Использование = Истина;
		КонецЕсли;
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ОтображатьВыбывшиеТС") Тогда 
			ТекПараметр.Значение      = ТСВыбыло;
			ТекПараметр.Использование = Истина;
		КонецЕсли;
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ТолькоПодписанные") Тогда 
			ТекПараметр.Значение      = ТолькоПодписанные;
			ТекПараметр.Использование = Истина;
		КонецЕсли;
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("Журнал") Тогда 
			ТекПараметр.Значение      = Журнал;
			ТекПараметр.Использование = Истина;
		КонецЕсли;
		Если ТекПараметр.Параметр = Новый ПараметрКомпоновкиДанных("ВидКонтроля") Тогда 
			ТекПараметр.Значение      = ВидКонтроля;
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
	СхемаКомпоновкиДанных = Отчеты.уатЖурналУчетаПоказанийОдометра.ПолучитьМакет("ИсточникНастроекОтбораКомпоновщика");
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных();
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
	тблРезультат = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(тблРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	мсвВсеДокументыЖурнала = ПолучитьДокументыЖурнала(Журнал);
	
	Макет = Отчеты.уатЖурналУчетаПоказанийОдометра.ПолучитьМакет("Макет");
	
	ОбластьШапкаТаблицыВторойЛист = Макет.ПолучитьОбласть("ШапкаТаблицыВтораяСтраница");
	
	Если ПечататьТитульныйЛист Тогда
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		
		ОбластьЗаголовок.Параметры.Организация = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(
			уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(ТекОрганизация, ТекущаяДата()), "НаименованиеДляПечатныхФорм,ЮридическийАдрес,Телефоны");
			
		ОбластьЗаголовок.Параметры.ДатаНачала   = Журнал.ДатаНачала;
		ОбластьЗаголовок.Параметры.ДатаОкончания = Журнал.ДатаОкончания;
		
		ДокументРезультат.Вывести(ОбластьЗаголовок);
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;	
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	
	ВсегоЛистов = 1;
	
	//Для Сч = 1 По 10 Цикл // для проверки механизма перехода на другую страницу
		
	Для Каждого ВыборкаДетали Из тблРезультат Цикл
		НомерЗаписи = мсвВсеДокументыЖурнала.Найти(ВыборкаДетали.Документ);
		Если НомерЗаписи = Неопределено Тогда
			НомерЗаписи = 0;
		Иначе
			НомерЗаписи = НомерЗаписи + 1;
		КонецЕсли;
		
		ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");
		ЗаполнитьЗначенияСвойств(ОбластьДетальныхЗаписей.Параметры, ВыборкаДетали);
		ОбластьДетальныхЗаписей.Параметры.КонтролерФИО = уатОбщегоНазначения.уатФИОСотрудникаПолноеСтрокой(ВыборкаДетали.Контролер, ВыборкаДетали.ДатаКонтроля);
		ОбластьДетальныхЗаписей.Параметры.НомерЗаписи = НомерЗаписи;
		
		Если НЕ ДокументРезультат.ПроверитьВывод(ОбластьДетальныхЗаписей) Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			ДокументРезультат.Вывести(ОбластьШапкаТаблицыВторойЛист);
			ВсегоЛистов = ВсегоЛистов + 1;
		КонецЕсли;
		
		ДокументРезультат.Вывести(ОбластьДетальныхЗаписей);
	КонецЦикла;
	
	//КонецЦикла;
	
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
	МакетКомпоновки = Отчеты.уатЖурналУчетаПоказанийОдометра.ПолучитьМакет("ИсточникНастроекОтбораКомпоновщика");
	URLСхемы        = ПоместитьВоВременноеХранилище(МакетКомпоновки, УникальныйИдентификатор);
	
	НастройкиКомпоновки.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
	НастройкиКомпоновки.ЗагрузитьНастройки(МакетКомпоновки.НастройкиПоУмолчанию);
	
	// Сортировка
	СхемаКомпоновкиДанныхСортировка = Отчеты.уатЖурналУчетаПоказанийОдометра.ПолучитьМакет("ИсточникНастроекОтбораКомпоновщика");
	АдресСхемыКомпоновкиДанныхСортировка = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанныхСортировка, УникальныйИдентификатор);
	
	НастройкиКомпоновкиСортировка.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанныхСортировка));
	НастройкиКомпоновкиСортировка.ЗагрузитьНастройки(СхемаКомпоновкиДанныхСортировка.НастройкиПоУмолчанию);
	
	НастройкиПорядка = ХранилищеНастроекДанныхФорм.Загрузить(
		"Отчеты.уатЖурналУчетаПоказанийОдометра.Форма.ФормаОтчета",
		"уатЖурналУчетаПоказанийОдометра_НастройкиКомпоновщика_Порядок");
	
	Если НастройкиПорядка <> Неопределено 
		ИЛИ ТипЗнч(НастройкиПорядка) = Тип("ХранилищеЗначения") Тогда 
		
		Для Каждого ТекПорядок Из НастройкиПорядка.Получить().Элементы Цикл 
			НовыйПорядок = НастройкиКомпоновкиСортировка.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйПорядок, ТекПорядок);
		КонецЦикла;
	КонецЕсли;
	
	НастройкиОтчета = ХранилищеНастроекДанныхФорм.Загрузить(
		"Отчеты.уатЖурналУчетаПоказанийОдометра.Форма.ФормаОтчета",
		"уатЖурналУчетаПоказанийОдометра_Настройки");
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
		Если НастройкиОтчета.Свойство("ТолькоПодписанные") Тогда
			ТолькоПодписанные = НастройкиОтчета.ТолькоПодписанные;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Отчеты.уатЖурналУчетаПоказанийОдометра.Форма.ФормаОтчета",
		"уатЖурналУчетаПоказанийОдометра_НастройкиКомпоновщика_Порядок",
		Новый ХранилищеЗначения(НастройкиКомпоновкиСортировка.Настройки.Порядок));
		
	НастройкиОтчета = Новый Структура;
	НастройкиОтчета.Вставить("ПечататьТитульныйЛист", ПечататьТитульныйЛист);
	НастройкиОтчета.Вставить("ПечататьПоследнийЛист", ПечататьПоследнийЛист);
	НастройкиОтчета.Вставить("ТСВыбыло",              ТСВыбыло);
	НастройкиОтчета.Вставить("ТолькоПодписанные",     ТолькоПодписанные);
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Отчеты.уатЖурналУчетаПоказанийОдометра.Форма.ФормаОтчета",
		"уатЖурналУчетаПоказанийОдометра_Настройки",
		НастройкиОтчета);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДокументыЖурнала(Журнал)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатЖурналУчетаПоказанийОдометра.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.уатЖурналУчетаПоказанийОдометра КАК уатЖурналУчетаПоказанийОдометра
	|ГДЕ
	|	уатЖурналУчетаПоказанийОдометра.Журнал = &Журнал
	|	И уатЖурналУчетаПоказанийОдометра.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	уатЖурналУчетаПоказанийОдометра.Дата,
	|	уатЖурналУчетаПоказанийОдометра.Ссылка");
	Запрос.УстановитьПараметр("Журнал", Журнал);
	мсвДокументы = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат мсвДокументы;
КонецФункции
	
#КонецОбласти
