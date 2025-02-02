
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	
	Если НЕ ПолучитьФункциональнуюОпцию("уатУчетЗаказовНаТСвПутевыхЛистах") Тогда
		ТекСтруктура = КомпоновщикНастроек.Настройки.Структура;
		УдалитьГруппировкуЗаказ(ТекСтруктура); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура УдалитьГруппировкуЗаказ(Структура)
	Для каждого ЭлементСтруктуры Из Структура Цикл
		Для Каждого Поле Из ЭлементСтруктуры.Выбор.Элементы Цикл
			Если ТипЗнч(Поле) = Тип("ВыбранноеПолеКомпоновкиДанных") И Поле.Заголовок = "ЗаказНаТС" Тогда
				Поле.Использование = Ложь;
			КонецЕсли;
		КонецЦикла;
		УдалитьГруппировкуЗаказ(ЭлементСтруктуры.Структура);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
