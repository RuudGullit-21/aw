
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаЭлементаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если флВопросЗакрытиеФормы Тогда
		Отказ = Истина;
		Оповещ = Новый ОписаниеОповещения("ПередЗакрытиемВопрос", ЭтотОбъект);
		ПоказатьВопрос(Оповещ, "При проверке корректности заполнения документа возникли предупреждения!
			|Продолжить закрытие формы?", РежимДиалогаВопрос.ОКОтмена);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыТопливо

&НаКлиенте
Процедура ТопливоТСПриИзменении(Элемент)
	
	ТекСтрока = Элементы.Топливо.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекСтрока.ГСМ = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(
		уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекСтрока.ТС, "Модель"),
		"ОсновноеТопливо"
	);
	ТопливоГСМПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТопливоТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	уатИнтерфейсВводаТС.РеквизитТСНачалоВыбора(Элемент, Элементы.Топливо.ТекущиеДанные.ТС, ДанныеВыбора, СтандартнаяОбработка, СтруктураОтборТС());
КонецПроцедуры

&НаКлиенте
Процедура ТопливоТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	уатИнтерфейсВводаТС.РеквизитТСАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, СтруктураОтборТС());
КонецПроцедуры

&НаКлиенте
Процедура ТопливоТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	уатИнтерфейсВводаТС.РеквизитТСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, СтруктураОтборТС());
КонецПроцедуры

&НаКлиенте
Процедура ТопливоГСМНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("ЗначениеГСМДоИзменения", Элементы.Топливо.ТекущиеДанные.ГСМ);
	ОписаниеОповещенияЗакр  = Новый ОписаниеОповещения("ОписаниеОповещенияВыбораГСМ", ЭтотОбъект, ДополнительныеПараметры);
	
	уатЗащищенныеФункцииКлиент.СписокГСМдляТС(Объект.Организация, Элементы.Топливо.ТекущиеДанные.ТС,
		ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"),, Истина, ОписаниеОповещенияЗакр);
КонецПроцедуры

// Подключаемый динамически обработчик оповещения
&НаКлиенте
Процедура ОписаниеОповещенияВыбораГСМ(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Элементы.Топливо.ТекущиеДанные.ГСМ = Результат;
		Если ДопПараметры.ЗначениеГСМДоИзменения <> Результат Тогда 
			Модифицированность = Истина;
		КонецЕсли;
		ТопливоГСМПриИзменении(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТопливоГСМАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ТекСтрока = Элементы.Топливо.ТекущиеДанные;
	
	СтандартнаяОбработка = Ложь;
	мсвГруппДляОтбора = Новый Массив;
	мсвГруппДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"));
	ДопПараметры = Новый Структура("ТС, Организация", ТекСтрока.ТС, Объект.Организация);
	ДанныеВыбора = уатГСМ.ПолучитьСписокАвтоподбораПоляГСМ(Текст, мсвГруппДляОтбора, ДопПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ТопливоГСМОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ПараметрыПолученияДанных.СтрокаПоиска = "";
КонецПроцедуры

&НаКлиенте
Процедура ТопливоСтавкаНДСПриИзменении(Элемент)
	ТекСтрока = Элементы.Топливо.ТекущиеДанные;
	СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеСтавкиНДС(ТекСтрока.СтавкаНДС);
	ТекСтрока.СуммаНДС = ТекСтрока.Сумма * СтавкаНДС / 100;
КонецПроцедуры

&НаКлиенте
Процедура ТопливоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Если НЕ Копирование Тогда 
			Элементы.Топливо.ТекущиеДанные.СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
				ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяСтавкаНДС");	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТопливоГСМПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Топливо.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ГСМ) Тогда
		СтавкаНДС = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(СтрокаТабличнойЧасти.ГСМ, "СтавкаНДС");
		СтрокаТабличнойЧасти.СтавкаНДС = ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС, СтрокаТабличнойЧасти.СтавкаНДС);
		ТопливоСтавкаНДСПриИзменении(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТопливоСуммаПриИзменении(Элемент)
	ТекСтрока = Элементы.Топливо.ТекущиеДанные;
	СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеСтавкиНДС(ТекСтрока.СтавкаНДС);
	ТекСтрока.СуммаНДС = ТекСтрока.Сумма * СтавкаНДС / 100;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Функция СтруктураОтборТС()
	СтруктураОтбор = Новый Структура("Организация", Объект.Организация);
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		СтруктураОтбор.Вставить("Подразделение", Объект.Подразделение);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Колонна) Тогда
		СтруктураОтбор.Вставить("Колонна", Объект.Колонна);
	КонецЕсли;
	
	Возврат СтруктураОтбор;
КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемВопрос(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.ОК Тогда
		флВопросЗакрытиеФормы = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
