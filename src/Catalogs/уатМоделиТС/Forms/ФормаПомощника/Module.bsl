
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗначенияЗаполнения")
		И НЕ Параметры.ЗначенияЗаполнения = Неопределено Тогда
		
		ПланированиеТО             = Параметры.ЗначенияЗаполнения.ПланированиеТО;
		ПараметрВыработки          = Параметры.ЗначенияЗаполнения.ПараметрВыработки;
		ЗначениеПараметраВыработки = Параметры.ЗначенияЗаполнения.ЗначениеПараметраВыработки;
		ПериодичностьОбслуживания  = Параметры.ЗначенияЗаполнения.ПериодичностьОбслуживания;
		КоличествоПериодов         = Параметры.ЗначенияЗаполнения.КоличествоПериодов;
		Допуск                     = Параметры.ЗначенияЗаполнения.Допуск;
		ДопускПерОбслуживания      = Параметры.ЗначенияЗаполнения.ДопускПерОбслуживания;
		ВидОбслуживания            = Параметры.ЗначенияЗаполнения.ВидОбслуживания;

		ПредВидОбслуживания        = ВидОбслуживания;
	КонецЕсли;
	
	Если Параметры.Свойство("МодельТС") Тогда
		МодельТС = Параметры.МодельТС;
		
		НаборЗаписей = РегистрыСведений.уатСервиснаяКнижка.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.МодельТС.Установить(МодельТС);
		НаборЗаписей.Отбор.ТО.Установить(ВидОбслуживания);
		НаборЗаписей.Прочитать();
		
		Для Каждого ТекЗапись Из НаборЗаписей Цикл
			Если ТипЗнч(ТекЗапись.Номенклатура) = Тип("СправочникСсылка.Номенклатура") Тогда
				НоваяСтрока = Запчасти.Добавить();
			Иначе
				НоваяСтрока = Работы.Добавить();
			КонецЕсли;
			НоваяСтрока.Номенклатура = ТекЗапись.Номенклатура;
			НоваяСтрока.Количество   = ТекЗапись.Количество;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Применить = Ложь;
	ВидимостьЭлементов();
	
	Если НЕ ЗначениеЗаполнено(ПланированиеТО) Тогда
		ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВремени");
	КонецЕсли;
	
	ПараметрВыработкиПриИзменении(Элементы.ПараметрВыработки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПланированиеТОПриИзменении(Элемент)
	
	Если ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВремени") Тогда
		КоличествоПериодов = 1;  
	Иначе
		КоличествоПериодов = Неопределено;
	КонецЕсли;
	ВидимостьЭлементов();
	
	ПериодичностьОбслуживания  = Неопределено;
	ПараметрВыработки          = Неопределено;
	ЗначениеПараметраВыработки = Неопределено;
	Допуск                     = Неопределено;
	ДопускПерОбслуживания      = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрВыработкиПриИзменении(Элемент)
	
	ЕдиницаИзмерения = ПолучитьЕдиницуИзмерения();
	ЕдиницаИзмеренияСтрока = ?(ЗначениеЗаполнено(ЕдиницаИзмерения)," (" + ЕдиницаИзмерения + ")","");
	
	Элементы.ЗначениеПараметраВыработки.Заголовок = НСтр("en='Parameter value';ru='Значение параметра'") + ЕдиницаИзмеренияСтрока;
	Элементы.ДопускПараметрВыработки.Заголовок = НСтр("en='Access';ru='Допуск'") + ЕдиницаИзмеренияСтрока;
	Элементы.ЧтоНаступитРаньше_ЗначениеПараметраВыработки.Заголовок = НСтр("en='Parameter value';ru='Значение параметра'") + ЕдиницаИзмеренияСтрока;
	Элементы.ЧтоНаступитРаньше_ДопускПараметрВыработки.Заголовок = НСтр("en='Access';ru='Допуск'") + ЕдиницаИзмеренияСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура РаботыНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПриЗакрытииФормы = Новый ОписаниеОповещения("ПослеЗакрытияФормыПодбора",ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.уатФормаПодбораСвязанныхРаботЗапчастей", Новый Структура("РаботаПоОбслуживанию", 
		ВыбранноеЗначение),,,ВариантОткрытияОкна.ОтдельноеОкно,,ПриЗакрытииФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Готово();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово()
	
	Если НЕ ЗначениеЗаполнено(ВидОбслуживания) Тогда
		ТекстНСТР = НСтр("ru='Поле ""Вид обслуживания"" не заполено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР,,"ВидОбслуживания","ВидОбслуживания");
		Возврат;
	КонецЕсли;
	
	СписокРабот     = "";
	СписокЗапчастей = "";
	ЗаписатьСервиснуюКнижку(СписокРабот, СписокЗапчастей);
	
	Применить = Истина;

	ЗначенияЗаполнения = Новый Структура();
	ЗначенияЗаполнения.Вставить("ВидОбслуживания",            ВидОбслуживания);
	ЗначенияЗаполнения.Вставить("ПериодичностьОбслуживания",  ПериодичностьОбслуживания);
	ЗначенияЗаполнения.Вставить("КоличествоПериодов",         КоличествоПериодов);
	ЗначенияЗаполнения.Вставить("ПараметрВыработки",          ПараметрВыработки);
	ЗначенияЗаполнения.Вставить("ЗначениеПараметраВыработки", ЗначениеПараметраВыработки);
	ЗначенияЗаполнения.Вставить("ПланированиеТО",             ПланированиеТО);
	ЗначенияЗаполнения.Вставить("Допуск",                     Допуск);
	ЗначенияЗаполнения.Вставить("ДопускПерОбслуживания",      ДопускПерОбслуживания);
	ЗначенияЗаполнения.Вставить("СписокРабот",                СписокРабот);
	ЗначенияЗаполнения.Вставить("СписокЗапчастей",            СписокЗапчастей);
	ЗначенияЗаполнения.Вставить("Применить",                  Применить);
	
	Закрыть(ЗначенияЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьСервиснуюКнижку(СписокРабот, СписокЗапчастей)
	
	НаборЗаписей = РегистрыСведений.уатСервиснаяКнижка.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.МодельТС.Установить(МодельТС);
	НаборЗаписей.Отбор.ТО.Установить(ВидОбслуживания);
	НаборЗаписей.Записать();
	
	Для Каждого ТекСтрока Из Работы Цикл
		
		НаборЗаписей = РегистрыСведений.уатСервиснаяКнижка.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.МодельТС.Установить(МодельТС);
		НаборЗаписей.Отбор.ТО.Установить(ВидОбслуживания);
		НаборЗаписей.Отбор.Номенклатура.Установить(ТекСтрока.Номенклатура);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			НовЗапись = НаборЗаписей.Добавить();
			НовЗапись.МодельТС     = МодельТС;
			НовЗапись.ТО           = ВидОбслуживания;
			НовЗапись.Номенклатура = ТекСтрока.Номенклатура;
			НовЗапись.Количество   = ?(ЗначениеЗаполнено(ТекСтрока.Количество), ТекСтрока.Количество, 1);
			НовЗапись.Привязана    = Истина;
			
			СписокРабот = ?(ЗначениеЗаполнено(СписокРабот), СписокРабот + ", ", "") + ТекСтрока.Номенклатура;
		Иначе
			НаборЗаписей[0].Количество   = НаборЗаписей[0].Количество + ТекСтрока.Количество;
			НовЗапись.Привязана = Истина;
		КонецЕСли;
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
	
	Для Каждого ТекСтрока Из Запчасти Цикл
		НаборЗаписей = РегистрыСведений.уатСервиснаяКнижка.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.МодельТС.Установить(МодельТС);
		НаборЗаписей.Отбор.ТО.Установить(ВидОбслуживания);
		НаборЗаписей.Отбор.Номенклатура.Установить(ТекСтрока.Номенклатура);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда
			НовЗапись = НаборЗаписей.Добавить();
			НовЗапись.МодельТС     = МодельТС;
			НовЗапись.ТО           = ВидОбслуживания;
			НовЗапись.Номенклатура = ТекСтрока.Номенклатура;
			НовЗапись.Количество   = ?(ЗначениеЗаполнено(ТекСтрока.Количество), ТекСтрока.Количество, 1);
			НовЗапись.Привязана = Истина;
			СписокЗапчастей = ?(ЗначениеЗаполнено(СписокЗапчастей), СписокЗапчастей + ", ", "") + ТекСтрока.Номенклатура;
		Иначе
			НаборЗаписей[0].Количество   = НаборЗаписей[0].Количество + ТекСтрока.Количество;
			НовЗапись.Привязана = Истина;
		КонецЕСли;
		НаборЗаписей.Записать(Истина);
	КонецЦикла;

	Если ПредВидОбслуживания <> ВидОбслуживания 
		И ЗначениеЗаполнено(ПредВидОбслуживания) Тогда
		НаборЗаписей = РегистрыСведений.уатСервиснаяКнижка.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.МодельТС.Установить(МодельТС);
		НаборЗаписей.Отбор.ТО.Установить(ПредВидОбслуживания);
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьЭлементов()
	
	Элементы.Готово.Заголовок                     = Нстр("en = 'Done'; ru = 'Готово'");
	
	Если ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВремени") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоВремени;
		Если КоличествоПериодов = 0 Тогда
			КоличествоПериодов = 1;
		КонецЕсли;
	ИначеЕсли ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ПоВыработке") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоВыработке;
	ИначеЕсли ПланированиеТО = ПредопределенноеЗначение("Перечисление.уатПериодичностьТО.ЧтоНаступитРаньше") Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаЧтоНаступитРаньше;
		Если КоличествоПериодов = 0 Тогда
			КоличествоПериодов = 1;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЕдиницуИзмерения()
	
	Возврат ПараметрВыработки.ЕдиницаИзмерения; 
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияФормыПодбора(ЗначенияЗаполнения,Параметр) Экспорт	
	Если НЕ ЗначенияЗаполнения = Неопределено
		И ЗначенияЗаполнения.Свойство("Работы")
		И ЗначенияЗаполнения.Свойство("Запчасти")Тогда
		
		Для Каждого ТекСтрока Из ЗначенияЗаполнения.Работы Цикл
			мсвСтрок = Работы.НайтиСтроки(Новый Структура("Номенклатура", ТекСтрока.Номенклатура));
			Если мсвСтрок.Количество() <> 0 Тогда
				мсвСтрок[0].Количество = мсвСтрок[0].Количество + ТекСтрока.Количество;
			Иначе
				НоваяСтрока = Работы.Добавить();
				НоваяСтрока.Номенклатура = ТекСтрока.Номенклатура;
				НоваяСтрока.Количество   = ТекСтрока.Количество;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ТекСтрока Из ЗначенияЗаполнения.Запчасти Цикл
			мсвСтрок = Работы.НайтиСтроки(Новый Структура("Номенклатура", ТекСтрока.Номенклатура));
			Если мсвСтрок.Количество() <> 0 Тогда
				мсвСтрок[0].Количество = мсвСтрок[0].Количество + ТекСтрока.Количество;
			Иначе
				НоваяСтрока = Запчасти.Добавить();
				НоваяСтрока.Номенклатура = ТекСтрока.Номенклатура;
				НоваяСтрока.Количество   = ТекСтрока.Количество;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти







