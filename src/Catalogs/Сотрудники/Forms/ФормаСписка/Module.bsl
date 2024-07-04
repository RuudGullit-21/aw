&НаКлиенте
Перем мсвСотрудникиДляОбновления;


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	уатЗащищенныеФункцииСервер.уатОбработкаФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка,ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Сотрудники);
    Элементы.СотрудникиСписокИзменитьВыделенные.Видимость = МожноРедактировать;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ОписаниеСотрудника = Новый ОписаниеТипов("СправочникСсылка.Сотрудники");
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = Новый ОписаниеТипов("СправочникСсылка.Сотрудники");
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СотрудникиСписокКоманднаяПанель;
	ПараметрыРазмещения.ПрефиксГрупп = "СотрудникиСписок";
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.РежимВыбора Тогда
		Элементы.СотрудникиСписок.РежимВыбора = Истина;
	Иначе
		СтруктураНастроек = ВосстановитьНастройки();
		НастройкиНекорректны = (СтруктураНастроек = Неопределено ИЛИ ТипЗнч(СтруктураНастроек) <> Тип("Структура"));
		
		Если НастройкиНекорректны ИЛИ (НЕ СтруктураНастроек.Свойство("ОтображатьУволенных")) Тогда
			ОтображатьУволенных = Ложь;
		Иначе
			ОтображатьУволенных = СтруктураНастроек.ОтображатьУволенных;
		КонецЕсли;
		
		Если НастройкиНекорректны ИЛИ (НЕ СтруктураНастроек.Свойство("ОтображатьСкрытых")) Тогда
			ОтображатьСкрытых = Ложь;
		Иначе
			ОтображатьСкрытых = СтруктураНастроек.ОтображатьСкрытых;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Организация") Тогда
		 ОтборОрганизация = Параметры.Отбор.Организация;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОтборОрганизация = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	КонецЕсли;
	
	Элементы.ОтображатьСкрытых.Видимость = Константы.ИспользоватьСкрытиеПерсональныхДанныхСубъектов.Получить();
	СотрудникиСписок.Параметры.УстановитьЗначениеПараметра("ОтборСкрытых", Не ОтображатьСкрытых);
	
	мДниДоОкончанияДействияДокументовВодителей = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
		уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(),
		"ОсновнаяОрганизация"), ПланыВидовХарактеристик.уатПраваИНастройки.ДниДоОкончанияДействияДокументовВодителей);
	мДниДоОкончанияДействияТопливныхКарт = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(
		уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(),
		"ОсновнаяОрганизация"), ПланыВидовХарактеристик.уатПраваИНастройки.ДниДоОкончанияДействияТопливныхКарт);
		
	СотрудникиСписок.ТекстЗапроса = СтрЗаменить(СотрудникиСписок.ТекстЗапроса, "__СОСТОЯНИЕ_УВОЛЕН_", НСтр("en='fired';ru='уволен'"));
	
	Парам = СотрудникиСписок.Параметры.Элементы.Найти("ДниДоОкончанияДействияДокументовВодителей");
	Парам.Значение = мДниДоОкончанияДействияДокументовВодителей;
	Парам.Использование = Истина;
	Парам = СотрудникиСписок.Параметры.Элементы.Найти("ДниДоОкончанияДействияТопливныхКарт");
	Парам.Значение = мДниДоОкончанияДействияТопливныхКарт;
	Парам.Использование = Истина;
	Парам = СотрудникиСписок.Параметры.Элементы.Найти("ТекущаяДата");
	Парам.Значение = НачалоДня(ТекущаяДата());
	Парам.Использование = Истина;
	
	Парам = ДокументыВодителей.Параметры.Элементы.Найти("ДниДоОкончанияДействияДокументовВодителей");
	Парам.Значение = мДниДоОкончанияДействияДокументовВодителей;
	Парам.Использование = Истина;
	
	Парам = ДокументыВодителей.Параметры.Элементы.Найти("ТекущаяДата");
	Парам.Значение = НачалоДня(ТекущаяДата());
	Парам.Использование = Истина;
	
	Парам = ПластиковыеКарты.Параметры.Элементы.Найти("ТекущаяДата");
	Парам.Значение = НачалоДня(ТекущаяДата());
	Парам.Использование = Истина;
	Парам = ПластиковыеКарты.Параметры.Элементы.Найти("ДниДоОкончанияДействияТопливныхКарт");
	Парам.Значение = мДниДоОкончанияДействияТопливныхКарт;
	Парам.Использование = Истина;
	
	НаборДопРеквизитов = ПолучитьНаборДопРеквизитов();
	УстановитьВидимость();
		
	// В случае поставки КОРП или ПРОФ свойства динамического списка тарифов ЗП сотрудников переопределяются,
	// делается запрос к другому регистру сведений, изначально список настроен для корректной работы в УАТ СТД
	ВариантПоставкиПРОФКОРП = уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП() Или уатОбщегоНазначенияПовтИсп.ВариантПоставкиПРОФ();
	Если ВариантПоставкиПРОФКОРП Тогда	
		СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		СвойстваСписка.ОсновнаяТаблица = "РегистрСведений.уатТарифыСотрудников.СрезПоследних";
		СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
		СвойстваСписка.ТекстЗапроса = ТекстЗапросаТарифовЗПСотрудниковПРОФКОРП();
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.ТарифыСотрудников,
		СвойстваСписка);	
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.НастроитьПолеПодразделение(Элементы.ОтборПодразделение, "ОтборОрганизация");
	
	// Поле "Сотрудник" не предназначено для использования в пользовательских настройках, поэтому оно исключается из них
	ПоляИсключаемыеИзПользовательскихНастроек = Новый Массив;
	ПоляИсключаемыеИзПользовательскихНастроек.Добавить("Сотрудник");
	СотрудникиСписок.УстановитьОграниченияИспользованияВОтборе(ПоляИсключаемыеИзПользовательскихНастроек);
	
	// Список тарифов ЗП сотрудника не предназначен для просмотра пользователями с отсутствующими правами
	Если Не ПравоДоступа("Просмотр", Метаданные.Справочники.уатТарифыЗП) Тогда
		Элементы.ГруппаТарифыЗП.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатОбработкаФормаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОтборОрганизацияПриИзменении(Неопределено);
	НастроитьОтборы();
	УстановитьОтборУволенных();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗаписанСотрудник" Тогда
		Элементы.КадроваяИстория.Обновить();
		Если НаборДопРеквизитов <> Неопределено Тогда
			ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
			Если ТекСтрока <> Неопределено Тогда
				Если ТекСтрока.Ссылка = Параметр Тогда
					ПолучитьДопРеквизиты(Параметр);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "СкрытыПерсональныеДанные"
		ИЛИ ИмяСобытия = "ИзменениеМестаРаботыСотрудника" Тогда
		Элементы.СотрудникиСписок.Обновить();
	ИначеЕсли ИмяСобытия = "РегистрационныеДокументы_Запись" Тогда
		Элементы.ДокументыВодителей.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СотрудникиСписок, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
КонецПроцедуры

&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СотрудникиСписок, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	#Если ВебКлиент Тогда
		ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
		Если ТекСтрока = Неопределено Тогда
			ТекСотрудник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
		Иначе
			ТекСотрудник = ТекСтрока.Ссылка;
		КонецЕсли;
		
		Если ТекущаяСтраница = Элементы.ГруппаКадроваяИстория Тогда
			ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(КадроваяИстория, "Сотрудник", ТекСотрудник, Истина);
		ИначеЕсли ТекущаяСтраница = Элементы.ГруппаВодитДокументы Тогда
			ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДокументыВодителей, "ВладелецДокументов", ТекСотрудник, Истина);
		ИначеЕсли ТекущаяСтраница = Элементы.ГруппаТарифыЗП Тогда
			ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ТарифыСотрудников, "Сотрудник", ТекСотрудник, Истина);
		ИначеЕсли ТекущаяСтраница = Элементы.ГруппаЭкипажТС Тогда
			ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ЭкипажТС, "Сотрудник", ТекСотрудник, Истина);
		ИначеЕсли ТекущаяСтраница = Элементы.ГруппаПластиковыеКарты Тогда
			ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ПластиковыеКарты, "КомуВыдана", ТекСотрудник, Истина);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУволенныхПриИзменении(Элемент)
	УстановитьОтборУволенных();
	СохранитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьСкрытыхПриИзменении(Элемент)
	СотрудникиСписок.Параметры.УстановитьЗначениеПараметра("ОтборСкрытых", Не ОтображатьСкрытых);
	
	СохранитьНастройки();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудникиСписок

&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	НастроитьОтборы();
	
	// Для групп сотрудников недоступны тарифы з/п, документы водителей и т.п.
	// Для группировок динамического списка данные параметры также недоступны
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	
	Если (ТекСтрока = Неопределено) Тогда
		АктивенСотрудник = Ложь;
	ИначеЕсли (ТекСтрока.Свойство("ГруппировкаСтроки")) Тогда
		АктивенСотрудник = Ложь;
	Иначе
		АктивенСотрудник = Не ТекСтрока.ЭтоГруппа;	
	КонецЕсли;
	
	Элементы.КадроваяИстория.Доступность = АктивенСотрудник;
	Элементы.ДокументыВодителей.Доступность = АктивенСотрудник;
	Элементы.ТарифыСотрудников.Доступность = АктивенСотрудник;
	Элементы.ЭкипажТС.Доступность = АктивенСотрудник;
	Элементы.ПластиковыеКарты.Доступность = АктивенСотрудник;

КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ОповещениеОИзменении = Новый ОписаниеОповещения("ОбновитьСписокСотрудниковПослеИзменения", ЭтотОбъект);
	
	Если Группа Тогда 
		ОткрытьФорму("Справочник.Сотрудники.ФормаГруппы", Новый Структура("ЭтоГруппа", Истина),,,,, ОповещениеОИзменении);
	Иначе 
		ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаЭлемента",,,,,, ОповещениеОИзменении);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	// Попытка выполнить изменение не сотрудника, а группировки справочника или динамического списка
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Элемент.ТекущиеДанные.Свойство("ГруппировкаСтроки") Тогда
		Возврат;
	КонецЕсли;
 
	СотрудникСсылка = Элемент.ТекущиеДанные.Ссылка;
	
	ПараметрыОткрытия = Новый Структура("Ключ", СотрудникСсылка);
	
	ОповещениеОИзменении = Новый ОписаниеОповещения("ОбновитьСписокСотрудниковПослеИзменения", ЭтотОбъект);
	
	Если уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(СотрудникСсылка, "ЭтоГруппа") Тогда 
		ОткрытьФорму("Справочник.Сотрудники.ФормаГруппы", ПараметрыОткрытия,,,,, ОповещениеОИзменении);
	Иначе 
		Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
			ПараметрыОткрытия.Вставить("ТекущаяОрганизация", ОтборОрганизация);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаЭлемента", ПараметрыОткрытия,,,,, ОповещениеОИзменении);
	КонецЕсли;
	
КонецПроцедуры

// Динамически подключаемый обработчик обновления списка сотрудников.
&НаКлиенте
Процедура ОбновитьСписокСотрудниковПослеИзменения(Результат, ДопПараметры) Экспорт
	
	Элементы.СотрудникиСписок.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле = Элементы.ЕстьПросроченныеДокументы Тогда
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОткрытия = Новый Структура("Отбор", Новый Структура("ВладелецДокументов, ПринадлежностьДокументов",
			ВыбраннаяСтрока, ПредопределенноеЗначение("Перечисление.уатПринадлежностьДокументов.ДокументыВодителя")));
		ОткрытьФорму("Справочник.уатРегистрационныеДокументы.ФормаСписка", ПараметрыОткрытия);
	ИначеЕсли НЕ Элементы.СотрудникиСписок.РежимВыбора Тогда
		ТекущиеДанные = Элементы.СотрудникиСписок.ТекущиеДанные;
		
		// Попытка выбрать не сотрудника, а группировки динамического списка
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		ИначеЕсли ТекущиеДанные.Свойство("ГруппировкаСтроки") Тогда
			Возврат;
		КонецЕсли;

		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытия = Новый Структура("Ключ", ТекущиеДанные.Ссылка);
		
		Если уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекущиеДанные.Ссылка, "ЭтоГруппа") Тогда 
			ОткрытьФорму("Справочник.Сотрудники.ФормаГруппы", ПараметрыОткрытия, ЭтотОбъект);
		Иначе
			ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаЭлемента", ПараметрыОткрытия, ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСвязаннаяИнформация

&НаКлиенте
Процедура КадроваяИсторияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	Если НЕ Копирование И ТекСтрока = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Если НЕ Копирование Тогда
			Отказ = Истина;
			ПараметрыОткрытия = Новый Структура("Сотрудник", ТекСтрока.Ссылка);
			ОткрытьФорму("РегистрСведений.уатКадроваяИсторияСотрудников.ФормаЗаписи", ПараметрыОткрытия,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура КадроваяИсторияПередУдалением(Элемент, Отказ)
	мсвСотрудникиДляОбновления = ПолучитьСотрудниковДляОбновления(Элементы.КадроваяИстория.ВыделенныеСтроки);
КонецПроцедуры

&НаКлиенте
Процедура КадроваяИсторияПослеУдаления(Элемент)
	уатОбщегоНазначенияСервер.ОбновитьТекущееМестоРаботыВСправочникеСотрудники(мсвСотрудникиДляОбновления);
	Оповестить("ИзменениеМестаРаботыСотрудника", мсвСотрудникиДляОбновления);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыВодителейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	Если НЕ Копирование И ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Если НЕ Копирование Тогда
			Отказ = Истина;
			ПараметрыОткрытия = Новый Структура("ВладелецДокументов, ПринадлежностьДокументов",
				ТекСтрока.Ссылка, ПредопределенноеЗначение("Перечисление.уатПринадлежностьДокументов.ДокументыВодителя"));
			ОткрытьФорму("Справочник.уатРегистрационныеДокументы.ФормаСписка", ПараметрыОткрытия,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ТарифыСотрудниковПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	Если НЕ Копирование И ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Если НЕ Копирование Тогда
			Отказ = Истина;
			ПараметрыОткрытия = Новый Структура("Сотрудник", ТекСтрока.Ссылка);
			ОткрытьФорму("РегистрСведений.уатТарифыСотрудников.ФормаЗаписи", ПараметрыОткрытия,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ЭкипажТСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	Если НЕ Копирование И ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Если НЕ Копирование Тогда
			Отказ = Истина;
			ПараметрыОткрытия = Новый Структура("Сотрудник", ТекСтрока.Ссылка);
			ОткрытьФорму("РегистрСведений.уатЭкипажТС.ФормаЗаписи", ПараметрыОткрытия,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПластиковыеКартыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	Если НЕ Копирование И ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		Если НЕ Копирование Тогда
			Отказ = Истина;
			ПараметрыОткрытия = Новый Структура("КомуВыдана", ТекСтрока.Ссылка);
			ОткрытьФорму("Справочник.уатПластиковыеКарты.ФормаОбъекта", ПараметрыОткрытия,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.СотрудникиСписок);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПечатьГрафика(Команда)
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	ПараметрыФормы = Новый Структура("Сотрудник", ТекСтрока.Ссылка);
	ОткрытьФорму("ОбщаяФорма.уатФормаГрафикРаботы", ПараметрыФормы, , ТекСтрока.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.СотрудникиСписок, СотрудникиСписок);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокументыСотрудникаПоФизЛицу(Команда)
	ТекущиеДанные = Элементы.СотрудникиСписок.ТекущиеДанные; 
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Сотрудник", ТекущиеДанные.Ссылка);
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаЗаполненияДокументовСотрудникаПоФизЛицу", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.СотрудникиСписок);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СотрудникиСписок);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервереБезКонтекста
Функция ВосстановитьНастройки()
	СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить("Справочник.Сотрудники.Форма.ФормаСписка", "ОбщиеНастройки");
	
	Возврат СтруктураНастроек;
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОтображатьУволенных", ОтображатьУволенных);
	СтруктураНастроек.Вставить("ОтображатьСкрытых", ОтображатьСкрытых);
	
	ХранилищеНастроекДанныхФорм.Сохранить("Справочник.Сотрудники.Форма.ФормаСписка", "ОбщиеНастройки", СтруктураНастроек);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборУволенных()
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СотрудникиСписок, "ДатаУвольнения", '00010101', НЕ ОтображатьУволенных);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы()
	ТекСтрока = Элементы.СотрудникиСписок.ТекущиеДанные;
	
	Если ТекСтрока = Неопределено 
		ИЛИ НЕ ТекСтрока.Свойство("Ссылка") Тогда
		ТекСотрудник = ПредопределенноеЗначение("Справочник.Сотрудники.ПустаяСсылка");
	Иначе
		ТекСотрудник = ТекСтрока.Ссылка;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ДокументыВодителей, "ВладелецДокументов", ТекСотрудник, Истина);
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ПластиковыеКарты, "КомуВыдана", ТекСотрудник, Истина);
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(КадроваяИстория, "Сотрудник", ТекСотрудник, Истина);
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ТарифыСотрудников, "Сотрудник", ТекСотрудник, Истина);
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(ЭкипажТС, "Сотрудник", ТекСотрудник, Истина);
	Если НаборДопРеквизитов <> Неопределено Тогда
		ПолучитьДопРеквизиты(ТекСотрудник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДопРеквизиты(ТекСотрудник)
	МассивДопРеквизиты = ПолучитьДопРеквизитыСервер(ТекСотрудник);
	ДополнительныеРеквизиты.Очистить();
	Если ЗначениеЗаполнено(МассивДопРеквизиты) Тогда
		Для Каждого ДопРеквизит Из МассивДопРеквизиты Цикл
			НоваяСтрока = ДополнительныеРеквизиты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ДопРеквизит);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДопРеквизитыСервер(ТекСотрудник)
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК ПометкаУдаления,
	|	НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.Свойство КАК Свойство,
	|	Сотрудники.Ссылка КАК Сотрудник
	|ПОМЕСТИТЬ СотрудникСвойства
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Сотрудники.Ссылка = &Сотрудник
	|	И НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.Ссылка В ИЕРАРХИИ(&Ссылка)
	|	И Сотрудники.ЭтоГруппа = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕСТЬNULL(СотрудникиДополнительныеРеквизиты.Значение, """") КАК Значение,
	|	СотрудникСвойства.ПометкаУдаления КАК ПометкаУдаления,
	|	СотрудникСвойства.Свойство КАК Свойство
	|ПОМЕСТИТЬ ДопРеквизиты
	|ИЗ
	|	СотрудникСвойства КАК СотрудникСвойства
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники.ДополнительныеРеквизиты КАК СотрудникиДополнительныеРеквизиты
	|		ПО СотрудникСвойства.Сотрудник = СотрудникиДополнительныеРеквизиты.Ссылка
	|			И СотрудникСвойства.Свойство = СотрудникиДополнительныеРеквизиты.Свойство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДопРеквизиты.Значение КАК Значение,
	|	ДопРеквизиты.ПометкаУдаления КАК ПометкаУдаления,
	|	ДопРеквизиты.Свойство КАК Свойство
	|ИЗ
	|	ДопРеквизиты КАК ДопРеквизиты
	|ГДЕ
	|	ВЫБОР
	|			КОГДА ДопРеквизиты.ПометкаУдаления = 4
	|					И ДопРеквизиты.Значение = """"
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	Запрос.УстановитьПараметр("Сотрудник", ТекСотрудник);
	Запрос.УстановитьПараметр("Ссылка", ПолучитьНаборДопРеквизитов());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		МассивДопРеквизиты = Новый Массив;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ДопРеквизит = Новый Структура("Значение, ПометкаУдаления, Свойство");
			ЗаполнитьЗначенияСвойств(ДопРеквизит, Выборка);
			МассивДопРеквизиты.Добавить(ДопРеквизит);
		КонецЦикла;
		Возврат МассивДопРеквизиты;
	КонецЕсли;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьНаборДопРеквизитов()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НаборыСвойств.Ссылка КАК Ссылка,
	|	НаборыСвойств.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК НаборыСвойств
	|ГДЕ
	|	НаборыСвойств.Предопределенный
	|	И НаборыСвойств.ИмяПредопределенныхДанных = ""Справочник_Сотрудники""";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		НаборСсылка = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат НаборСсылка;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимость()
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.Свойство КАК Свойство
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений.ДополнительныеРеквизиты КАК НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты
	|ГДЕ
	|	НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.Ссылка В ИЕРАРХИИ(&Ссылка)
	|	И НаборыДополнительныхРеквизитовИСведенийДополнительныеРеквизиты.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("Ссылка", НаборДопРеквизитов);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Или НЕ ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения") Тогда
		Элементы.ГруппаДополнительныеРеквизиты.Видимость = Ложь;
	Иначе
		Элементы.ГруппаДополнительныеРеквизиты.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстЗапросаТарифовЗПСотрудниковПРОФКОРП()
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	РегистрСведенийуатТарифыСотрудниковСрезПоследних.Период КАК Период,
	|	РегистрСведенийуатТарифыСотрудниковСрезПоследних.Регистратор КАК Регистратор,
	|	РегистрСведенийуатТарифыСотрудниковСрезПоследних.НомерСтроки КАК НомерСтроки,
	|	РегистрСведенийуатТарифыСотрудниковСрезПоследних.Активность КАК Активность,
	|	РегистрСведенийуатТарифыСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	|	РегистрСведенийуатТарифыСотрудниковСрезПоследних.ТарифЗП КАК ТарифЗП,
	|	РегистрСведенийуатТарифыСотрудниковСрезПоследних.ДатаОкончания КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА РегистрСведенийуатТарифыСотрудниковСрезПоследних.ТарифЗП.ВидНачисления.СпособРасчетаОплатыТруда = ЗНАЧЕНИЕ(Перечисление.уатСпособыРасчетаОплатыТруда.СдельныйЗаработок)
	|			ТОГДА 0
	|		КОГДА РегистрСведенийуатТарифыСотрудниковСрезПоследних.ТарифЗП.ВидНачисления.СпособРасчетаОплатыТруда = ЗНАЧЕНИЕ(Перечисление.уатСпособыРасчетаОплатыТруда.ФиксированнойСуммой)
	|			ТОГДА 1
	|		КОГДА РегистрСведенийуатТарифыСотрудниковСрезПоследних.ТарифЗП.ВидНачисления.СпособРасчетаОплатыТруда = ЗНАЧЕНИЕ(Перечисление.уатСпособыРасчетаОплатыТруда.ПроцентомОтВыручки)
	|				ИЛИ РегистрСведенийуатТарифыСотрудниковСрезПоследних.ТарифЗП.ВидНачисления.СпособРасчетаОплатыТруда = ЗНАЧЕНИЕ(Перечисление.уатСпособыРасчетаОплатыТруда.ПроцентомОтВидовНачислений)
	|			ТОГДА 2
	|		КОГДА РегистрСведенийуатТарифыСотрудниковСрезПоследних.ТарифЗП.ВидНачисления.СпособРасчетаОплатыТруда = ЗНАЧЕНИЕ(Перечисление.уатСпособыРасчетаОплатыТруда.ДоплатаЗаНочныеЧасы)
	|				ИЛИ РегистрСведенийуатТарифыСотрудниковСрезПоследних.ТарифЗП.ВидНачисления.СпособРасчетаОплатыТруда = ЗНАЧЕНИЕ(Перечисление.уатСпособыРасчетаОплатыТруда.ДоплатаЗаПраздничныеИВыходные)
	|			ТОГДА 3
	|		ИНАЧЕ -1
	|	КОНЕЦ КАК ИконкаМетодРасчета
	|ИЗ
	|	РегистрСведений.уатТарифыСотрудников.СрезПоследних КАК РегистрСведенийуатТарифыСотрудниковСрезПоследних";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Функция ПолучитьСотрудниковДляОбновления(Знач ВыделенныеСтроки)
	мсвРез = Новый Массив;
	Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
		Если мсвРез.Найти(ТекСтрока.Сотрудник) = Неопределено Тогда
			мсвРез.Добавить(ТекСтрока.Сотрудник);
		КонецЕсли;
	КонецЦикла;
	
	Возврат мсвРез;
КонецФункции

#КонецОбласти
