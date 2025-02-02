
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// Внешнему пользователю физическому лицу запрещено открытие документов
	Если уатОбщегоНазначения.ПроверкаВнешнегоПользователя() И ТипЗнч(ПользователиКлиентСервер.АвторизованныйПользователь().ОбъектАвторизации) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
    ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ПравоДоступаНаРедактирование = ПравоДоступа("Редактирование", Метаданные.Документы.уатМаршрутныйЛист);
	Если Не ПравоДоступаНаРедактирование Тогда 
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
		Элементы.Закрытие.Видимость = Ложь;
	КонецЕсли;
	
	// Ограничение просмотра для внешнего пользователя
	АвторизованВнешнийПользователь = Ложь;
	АвторизованныйКонтрагент = уатЗащищенныеФункцииСервер_проф.АвторизованныйКонтрагент(АвторизованВнешнийПользователь);
	Если АвторизованВнешнийПользователь Тогда
		ЭлементОтбора                  = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Контрагент");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение   = АвторизованныйКонтрагент;
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.Использование    = Истина;
		
		Элементы.ПодменюПечать.Видимость = Ложь;
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.Закрытие.Видимость = Ложь;
		Если АвторизованВнешнийПользователь Тогда
			Элементы.СуммаДоходов.Видимость = Ложь;
		КонецЕсли;
		
		Если уатОбщегоНазначенияСервер.АвторизованВнещнийПеревозчик() Тогда
			КомандаСоздатьНаОсновании = Элементы.Найти("ФормаДокументуатСчетНаОплатуПоставщикаСоздатьНаОсновании");
			Если КомандаСоздатьНаОсновании <> Неопределено Тогда
				КомандаСоздатьНаОсновании.Заголовок = НСтр("ru = 'Счет на оплату'");
			КонецЕсли;
			КомандаСоздатьНаОсновании = Элементы.Найти("ФормаДокументуатПоступлениеТоваровУслугСоздатьНаОсновании");
			Если КомандаСоздатьНаОсновании <> Неопределено Тогда
				КомандаСоздатьНаОсновании.Заголовок = НСтр("ru = 'Реализация услуг'");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.ПереместитьКнопкуКонтакты(Элементы);
	
	Если ПолучитьФункциональнуюОпцию("уатИспользоватьДокументооборот") = Ложь Тогда
		Элементы.СтатусОбработкиСопроводительныхДокументов.Видимость = Ложь;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("уатИспользоватьИнтеграциюWMS_уэ") = Ложь Тогда
		ЭлементСтатусВыгрузкиВWMS = Элементы.Найти("СтатусВыгрузкиВWMS");
		Если ЭлементСтатусВыгрузкиВWMS <> Неопределено Тогда
			ЭлементСтатусВыгрузкиВWMS.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("уатРазделятьПланФактВСкладскихАктах_уэ") = Ложь Тогда
		Элементы.КартинкаЕстьРасхождения.Видимость = Ложь;
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
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ПравоДоступаНаРедактирование Тогда 
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПользователиКлиентСервер.АвторизованныйПользователь()) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Возврат;
	КонецЕсли;  
		
КонецПроцедуры

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
	
	//Если уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП() Тогда
		ИзменитьВыделенныеСтроки(Элементы.Список, Список);
	//Иначе
	//	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Закрытие(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекДатаЗакрытия = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекСтрока.Ссылка, "ДатаЗакрытия");
	Если ТекДатаЗакрытия <> '00010101' Тогда
		ТекстНСТР = НСтр("en='Document is already closed on date ""%1"". To cancel closing, open the document form.';ru='Документ уже закрыт на дату ""%1"". Для отмены закрытия откройте форму документа.'");
		ТекстНСТР = СтрШаблон(ТекстНСТР, ТекДатаЗакрытия);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
		Возврат;
	КонецЕсли;
	
	ДопПараметры = Новый Структура("Документ", ТекСтрока.Ссылка);
	ТекстНСТР = НСтр("en='Enter closing date and time';ru='Введите дату и время закрытия'");
	ПоказатьВводДаты(Новый ОписаниеОповещения("ЗакрытиеВводДатыЗавершение", ЭтотОбъект, ДопПараметры),
		ДатаЗакрытияПоУмолчанию(ТекСтрока.Ссылка), ТекстНСТР, ЧастиДаты.ДатаВремя)
КонецПроцедуры

&НаСервере
Функция ДатаЗакрытияПоУмолчанию(ДокументСсылка)
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
		Возврат Документы.уатМаршрутныйЛист.ДатаЗакрытияПоУмолчанию(ДокументСсылка, ТекущаяДата());
	Иначе
		Возврат ТекущаяДата();
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ЗакрытиеВводДатыЗавершение(Результат, ДопПараметры) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда
		СообщениеОшибки = "";
		флСуммаУслугИзменилась = Ложь;
		флПересчетИтогов = Ложь;
		ЗакрытиеЗаказаСервер(ДопПараметры.Документ, Результат, СообщениеОшибки, флСуммаУслугИзменилась, флПересчетИтогов);
		Если НЕ ПустаяСтрока(СообщениеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОшибки);
		Иначе
			Если флСуммаУслугИзменилась И НЕ флПересчетИтогов Тогда
				ПоказатьПредупреждение(Неопределено, НСтр("en='Recalculation of incomes and expenses not done';ru='Не выполнен пересчет доходов и расходов'"));
			КонецЕсли;
			Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗакрытиеЗаказаСервер(ДокументСсылка, ДатаЗакрытия, СообщениеОшибки = "", флСуммаУслугИзменилась = Ложь, флПересчетИтогов = Ложь)
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		Документы.уатМаршрутныйЛист.ЗакрытиеДокумента(ДокументСсылка, ДатаЗакрытия, СообщениеОшибки, Истина, флСуммаУслугИзменилась);
		флПересчетИтогов = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(), "МаршрутныйЛистПерерасчетИтоговПриПроведении");
	КонецЕсли;
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

&НаКлиенте
Процедура ИзменитьВыделенныеСтроки(СписокЭлемент, Знач СписокРеквизит = Неопределено)
	
	Если СписокРеквизит = Неопределено Тогда
		Форма = СписокЭлемент.Родитель;
		Пока ТипЗнч(Форма) <> Тип("УправляемаяФорма") Цикл
			Форма = Форма.Родитель;
		КонецЦикла;
		
		Попытка
			СписокРеквизит = Форма.Список;
		Исключение
			СписокРеквизит = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	ВыделенныеСтроки = СписокЭлемент.ВыделенныеСтроки;
	
	ПараметрыФормы = Новый Структура("МассивОбъектов", Новый Массив);
	Если ТипЗнч(СписокРеквизит) = Тип("ДинамическийСписок") Тогда
		ПараметрыФормы.Вставить("КомпоновщикНастроек", СписокРеквизит.КомпоновщикНастроек);
	КонецЕсли;
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущаяСтрока = СписокЭлемент.ДанныеСтроки(ВыделеннаяСтрока);
		Если ТекущаяСтрока <> Неопределено Тогда
			ПараметрыФормы.МассивОбъектов.Добавить(ТекущаяСтрока.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыФормы.МассивОбъектов.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта.';en='Command cannot be executed for the specified object.'"));
		Возврат;
	КонецЕсли;
		
	ОткрытьФорму("ОбщаяФорма.уатФормаОбработкиДокументов", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
