
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка,ДопПараметрыОткрытие);
	
	СтандартныеНастройкиПоступление = Справочники.уатШаблоныЗаполненияПоУслугам.СтандартныеНастройкиПоступление;
	СтандартныеНастройкиРеализация  = Справочники.уатШаблоныЗаполненияПоУслугам.СтандартныеНастройкиРеализация;
	
	Если уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		Элементы.СтандартныеНастройкиПоступление.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатРегистрФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеШаблоны(Команда)
	ОткрытьФорму("Справочник.уатШаблоныЗаполненияПоУслугам.ФормаСписка");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "Шаблон" Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Элементы.Список.ТекущиеДанные.Шаблон);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
