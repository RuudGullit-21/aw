
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализацияКомпоновщика();
	
	НастройкиЗагружены = Ложь;
	Если Параметры.Свойство("КлючНастроек") Тогда
		КлючНастроек = Параметры.КлючНастроек;
		ВосстановитьНастройки(КлючНастроек, НастройкиЗагружены);
	КонецЕсли;
	
	Если НЕ НастройкиЗагружены Тогда
		НовыйЭлементОтбора = КомпоновщикДанныхТС.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТС");
		НовыйЭлементОтбора.Использование = Ложь;
		НовыйЭлементОтбора.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
		
		Если Параметры.Свойство("Отборы") Тогда
			Для Каждого ТекСтрока Из Параметры.Отборы Цикл
				НовыйЭлементОтбора = КомпоновщикДанныхТС.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				НовыйЭлементОтбора.ЛевоеЗначение  = ТекСтрока.ЛевоеЗначение;
				НовыйЭлементОтбора.Использование  = ТекСтрока.Использование;
				НовыйЭлементОтбора.ВидСравнения   = ТекСтрока.ВидСравнения;
				НовыйЭлементОтбора.ПравоеЗначение = ТекСтрока.ПравоеЗначение;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючНастроек) Тогда
		СохранитьНастройки(КлючНастроек);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	НастройкиКомпоновки = ПолучитьНастройкиКомпоновщикаДанныхЗаказов();
	
	мсвТС = СформироватьМассивНаСервере(НастройкиКомпоновки);
	
	Закрыть(мсвТС);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВосстановитьНастройки(КлючНастроек, НастройкиЗагружены)
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда 
		СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить("Справочник.уатТС.Форма.ФормаЗаполнения", КлючНастроек);
	Иначе 
		СтруктураНастроек = Неопределено;
	КонецЕсли;
	
	Если Не ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиЗагружены = Истина;
	Если СтруктураНастроек.Свойство("Отбор") Тогда 
		ВосстановитьНастройкиОтбора(СтруктураНастроек.Отбор, КомпоновщикДанныхТС.Настройки.Отбор.Элементы);
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("Порядок") Тогда 
		Для Каждого ТекПорядок Из СтруктураНастроек.Порядок Цикл 
			Если ТекПорядок = Тип("АвтоЭлементПорядкаКомпоновкиДанных") Тогда
				НовПорядок = КомпоновщикДанныхТС.Настройки.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			Иначе
				НовПорядок = КомпоновщикДанныхТС.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
				ЗаполнитьЗначенияСвойств(НовПорядок, ТекПорядок);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиОтбора(мсвНастроек, ЭлементыОтбора)
	
	Для Каждого ТекОтбор Из мсвНастроек Цикл 
		Если ТекОтбор.Свойство("Элементы") Тогда 
			НовОтбор = ЭлементыОтбора.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовОтбор, ТекОтбор, "ТипГруппы, Использование");
			
			ВосстановитьНастройкиОтбора(ТекОтбор.Элементы, НовОтбор.Элементы);
			
		Иначе 
			НовОтбор = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовОтбор, ТекОтбор);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки(КлючНастроек)
	
	Если Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = Новый Структура("Отбор, Порядок", Новый Массив(), Новый Массив());
	
	ПолучитьНастройкиОтбора(СтруктураНастроек.Отбор, КомпоновщикДанныхТС.Настройки.Отбор.Элементы);
	
	Для Каждого ТекПорядок Из КомпоновщикДанныхТС.Настройки.Порядок.Элементы Цикл 
		Если ТипЗнч(ТекПорядок) = Тип("АвтоЭлементПорядкаКомпоновкиДанных") Тогда
			СтруктураНастроек.Порядок.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		Иначе
			стрПорядок = Новый Структура();
			стрПорядок.Вставить("Поле",              ТекПорядок.Поле);
			стрПорядок.Вставить("ТипУпорядочивания", ТекПорядок.ТипУпорядочивания);
			стрПорядок.Вставить("Использование",     ТекПорядок.Использование);
			
			СтруктураНастроек.Порядок.Добавить(стрПорядок);
		КонецЕсли;
	КонецЦикла;
	
	ХранилищеНастроекДанныхФорм.Сохранить("Справочник.уатТС.Форма.ФормаЗаполнения", КлючНастроек, СтруктураНастроек);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНастройкиОтбора(мсвНастроек, ЭлементыОтбора)
	
	Для Каждого ТекОтбор Из ЭлементыОтбора Цикл 
		стрОтбор = Новый Структура();
		
		Если ТипЗнч(ТекОтбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда 
			стрОтбор.Вставить("ТипГруппы",     ТекОтбор.ТипГруппы);
			стрОтбор.Вставить("Элементы",      Новый Массив());
			стрОтбор.Вставить("Использование", ТекОтбор.Использование);
			
			ПолучитьНастройкиОтбора(стрОтбор.Элементы, ТекОтбор.Элементы);
			
		Иначе 
			стрОтбор.Вставить("ЛевоеЗначение",  ТекОтбор.ЛевоеЗначение);
			стрОтбор.Вставить("ВидСравнения",   ТекОтбор.ВидСравнения);
			стрОтбор.Вставить("ПравоеЗначение", ТекОтбор.ПравоеЗначение);
			стрОтбор.Вставить("Использование",  ТекОтбор.Использование);
		КонецЕсли;
		
		мсвНастроек.Добавить(стрОтбор);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияКомпоновщика()
	
	СхемаКомпоновкиДанных = Справочники.уатТС.ПолучитьМакет("ОтборТС");
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	КомпоновщикДанныхТС.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	КомпоновщикДанныхТС.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНастройкиКомпоновщикаДанныхЗаказов()
	
	НастройкиКомпоновщикаДанных = КомпоновщикДанныхТС.ПолучитьНастройки();
	
	Возврат НастройкиКомпоновщикаДанных;
	
КонецФункции 

&НаСервере
Функция СформироватьМассивНаСервере(НастройкиКомпоновки)
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных), НастройкиКомпоновки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,,, Истина);   
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаДанныхТС = Новый ТаблицаЗначений;     
	ПроцессорВывода.УстановитьОбъект(ТаблицаДанныхТС);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	мсвТС = Новый Массив();
	Для Каждого ТекТС Из ТаблицаДанныхТС Цикл
		мсвТС.Добавить(ТекТС.Ссылка);
	КонецЦикла;
	
	Возврат мсвТС;
	
КонецФункции

#КонецОбласти
