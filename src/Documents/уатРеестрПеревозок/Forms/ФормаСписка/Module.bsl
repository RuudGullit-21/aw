
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// Внешнему пользователю физическому лицу запрещено открытие документов
	АвторизованныйПользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
	Если уатОбщегоНазначения.ПроверкаВнешнегоПользователя() И ТипЗнч(АвторизованныйПользователь.ОбъектАвторизации) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Документы.уатРеестрПеревозок) Тогда 
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	АвторизованВнешнийПользователь = Ложь;
	АвторизованныйКонтрагент = уатЗащищенныеФункцииСервер_проф.АвторизованныйКонтрагент(АвторизованВнешнийПользователь);
	Если АвторизованВнешнийПользователь Тогда
		ЭлементОтбора                  = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Перевозчик");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение   = АвторизованныйКонтрагент;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.Использование    = Истина;
		
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		
		Если уатОбщегоНазначенияСервер.АвторизованВнещнийПеревозчик() Тогда
			КомандаСоздатьНаОсновании = Элементы.Найти("ФормаДокументуатПоступлениеТоваровУслугСоздатьНаОсновании");
			Если КомандаСоздатьНаОсновании <> Неопределено Тогда
				КомандаСоздатьНаОсновании.Заголовок = НСтр("ru = 'Реализация услуг'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
	
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
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
