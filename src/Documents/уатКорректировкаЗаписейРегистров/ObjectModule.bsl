#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоНовый() И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(Ложь);
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	уатОбщегоНазначенияСервер.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает признак активности для записей регистров.
//
Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл
		
		Движение.Прочитать();
		Движение.УстановитьАктивность(ФлагАктивности);
			
	КонецЦикла;
	
КонецПроцедуры // УстановитьАктивностьДвижений()

#КонецОбласти
