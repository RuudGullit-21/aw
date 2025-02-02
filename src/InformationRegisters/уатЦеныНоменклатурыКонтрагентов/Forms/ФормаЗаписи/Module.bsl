#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка,ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатРегистрФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПередИзменением = Контрагент;
	Контрагент = Запись.Контрагент;
	Если ЗначениеЗаполнено(Запись.Номенклатура) Тогда
		Если ТипЗнч(КонтрагентПередИзменением) <> ТипЗнч(Запись.Контрагент)
			И ТипЗнч(Запись.Контрагент) = Тип("СправочникСсылка.уатАЗС") Тогда
			Если НЕ уатГСМ.ЭтоГСМ(Запись.Номенклатура) Тогда
				Запись.Номенклатура = ПредопределенноеЗначение("Справочник.Номенклатура.ПустаяСсылка");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыНоменклатура

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Запись.Контрагент)
		И ТипЗнч(Запись.Контрагент) = Тип("СправочникСсылка.уатАЗС") Тогда
		СтандартнаяОбработка = Ложь;
		
		ДополнительныеПараметры	 = Новый Структура("ЗначениеГСМДоИзменения, КлючУникальности, УчитыватьТЖ", Запись.Номенклатура, "ВыборНоменклатурыГСМ", Истина);
		ОписаниеОповещенияЗакр	 = Новый ОписаниеОповещения("ОписаниеОповещенияВыбораГСМ", ЭтотОбъект, ДополнительныеПараметры);

		СписокГруппГСМ = Новый СписокЗначений;
		СписокГруппГСМ.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"));
		уатЗащищенныеФункцииКлиент.ВыбратьГСМ(СписокГруппГСМ, ДополнительныеПараметры, ОписаниеОповещенияЗакр);
	КонецЕсли;
	
КонецПроцедуры

// Подключаемый динамически обработчик оповещения
&НаКлиенте
Процедура ОписаниеОповещенияВыбораГСМ(Результат, ДопПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запись.Номенклатура = Результат;
	
	Если Запись.Номенклатура <> ДопПараметры.ЗначениеГСМДоИзменения Тогда 
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Запись.Контрагент)
		И ТипЗнч(Запись.Контрагент) = Тип("СправочникСсылка.уатАЗС") Тогда
		СтандартнаяОбработка = Ложь;
		мсвГруппДляОтбора = Новый Массив;
		мсвГруппДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"));
		ДопПараметры = Новый Структура("УчитыватьТЖ", Истина);
		ДанныеВыбора = уатГСМ.ПолучитьСписокАвтоподбораПоляГСМ(Текст, мсвГруппДляОтбора, ДопПараметры);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Запись.Контрагент)
		И ТипЗнч(Запись.Контрагент) = Тип("СправочникСсылка.уатАЗС") Тогда
		ПараметрыПолученияДанных.СтрокаПоиска = "";
	КонецЕсли;
КонецПроцедуры


#КонецОбласти
