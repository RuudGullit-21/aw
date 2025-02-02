
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// Запрет на просмотр параметров выработки для внешнего пользователя.
	Если уатОбщегоНазначения.ПроверкаВнешнегоПользователя() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьЗаголовкиКОРП();
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.уатПараметрыВыработки) Тогда 
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	мсвЗапрещенныеКВыбору = Новый Массив();
	
	Если НЕ Константы.уатИспользоватьOmnicomm.Получить()
			И НЕ Константы.уатИспользоватьWialon.Получить()
			И НЕ Константы.уатИспользоватьАвтоГРАФ.Получить()
			И НЕ Константы.уатИспользоватьСКАУТ.Получить()
			И НЕ Константы.уатИспользоватьЦСМ.Получить() Тогда 
		мсвЗапрещенныеКВыбору.Добавить(Справочники.уатПараметрыВыработки.ПробегОбщийПоДаннымGPS);
		мсвЗапрещенныеКВыбору.Добавить(Справочники.уатПараметрыВыработки.ВремяВРаботеПоДаннымGPS);
	КонецЕсли;
	Если НЕ уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП() Тогда
		мсвЗапрещенныеКВыбору.Добавить(Справочники.уатПараметрыВыработки.КоличествоКонтейнеров);
	КонецЕсли;
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.НеВСписке;
	ЭлементОтбора.ПравоеЗначение   = мсвЗапрещенныеКВыбору;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Использование    = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборИспользоватьДляЗаказовПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ИспользоватьДляЗаказовИПотребности", ОтборИспользоватьДляЗаказов,,, ОтборИспользоватьДляЗаказов);
КонецПроцедуры

&НаКлиенте
Процедура ОтборИспользоватьДляМаршрутныхЛистовПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ИспользоватьДляМаршрутныхЛистов", ОтборИспользоватьДляМаршрутныхЛистов,,, ОтборИспользоватьДляМаршрутныхЛистов);
КонецПроцедуры

&НаКлиенте
Процедура ОтборИспользоватьДляТТДПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ИспользоватьВТарифахНаУслуги", ОтборИспользоватьДляТТД,,, ОтборИспользоватьДляТТД);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовкиКОРП()
	
	Если уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП() Тогда 
		Элементы.ОтборИспользоватьДляЗаказов.Заголовок = НСтр("en='Order for trucking, Need for the carriage';ru='Заказ на ТС, Потребность в перевозке'");
		Элементы.ИспользоватьДляЗаказовИПотребности.Заголовок = НСтр("en='Services in orders and requirements';ru='Заказ, Потребность'");
		Элементы.ИспользоватьДляЗаказовИПотребности.Подсказка = НСтр("en='Parameter will be used for the calculation of transportation services according to price lists in documents ""Order for trucking"", ""Order to carrier (by order for trucking)"" and ""Need for the carriage""';ru='Параметр будет использоваться при расчете транспортных услуг по прейскурантам в документах ""Заказ на ТС"", ""Заказ перевозчику (по заказам на ТС)"" и ""Потребность в перевозке""'");
	Иначе 
		Элементы.ОтборИспользоватьДляЗаказов.Заголовок = НСтр("en='Order for trucking';ru='Заказ на ТС'");
		Элементы.ИспользоватьДляЗаказовИПотребности.Заголовок = НСтр("en='Services in orders';ru='Заказ на ТС'");
		Элементы.ИспользоватьДляЗаказовИПотребности.Подсказка = НСтр("en='Parameter will be used for the calculation of transportation services according to price lists in documents ""Order for trucking"" and ""Order to carrier (by order for trucking)""';ru='Параметр будет использоваться при расчете транспортных услуг по прейскурантам в документах ""Заказ на ТС"" и ""Заказ перевозчику (по заказам на ТС)""'");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
