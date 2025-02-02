
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = НСтр("en='Ссылка на элемент отчета';ru='Ссылка на элемент отчета'");
	
	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтотОбъект);
	СвязанныйВидОтчета = Объект.СвязанныйЭлемент.Владелец;
	НаименованиеСвязанногоЭлемента = Объект.СвязанныйЭлемент.НаименованиеДляПечати;
	Наименование = ДанныеОбъекта.НаименованиеДляПечати;
	Если ПустаяСтрока(НаименованиеСвязанногоЭлемента) И НЕ ПустаяСтрока(Наименование) Тогда
		НаименованиеСвязанногоЭлемента = ДанныеОбъекта.НаименованиеДляПечати;
	КонецЕсли;
	ВидыЭлементов = Перечисления.ВидыЭлементовФинансовогоОтчета;
	ЭтоПоказатель = ДанныеОбъекта.ВидЭлемента = ВидыЭлементов.МонетарныйПоказатель
					ИЛИ ДанныеОбъекта.ВидЭлемента = ВидыЭлементов.НемонетарныйПоказатель
					ИЛИ ДанныеОбъекта.ВидЭлемента = ВидыЭлементов.ПроизводныйПоказатель
					ИЛИ (ДанныеОбъекта.ВидЭлемента = ВидыЭлементов.ИтогПоГруппе И ДанныеОбъекта.ЭтоСвязанный);

	Элементы.ОбратныйЗнак.Видимость = ЭтоПоказатель;
	Элементы.ВыделитьЭлемент.Видимость = ЭтоПоказатель;
	//СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ДопРежим = Перечисления.ДополнительныеРежимыЭлементовОтчетов.СвязанныйЭлемент;
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, Отказ, ДопРежим);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеДляПечатиПриИзменении(Элемент)

	Объект.Наименование = Объект.НаименованиеДляПечати;

КонецПроцедуры

&НаКлиенте
Процедура СвязанныйЭлементНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("Ключ", СвязанныйВидОтчета);
	//ПараметрыФормы.Вставить("ТекущийЭлементОтчета", Объект.СвязанныйЭлемент);
	//ОткрытьФорму("Справочник.ВидыФинансовыхОтчетов.ФормаОбъекта",ПараметрыФормы);
	//Закрыть();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)

	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	Заглушка = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
